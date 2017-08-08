package.path = "../lua_modules/share/lua/5.3/?.lua;../lua_modules/share/lua/5.3/?/init.lua"

local moonview = require("moonview")
local helpers  = require("moonview.helpers")
local Signal   = require("hump.signal")
local q        = helpers.q
local qall     = helpers.qall
local fetchj   = helpers.fetchj
local fetch    = helpers.fetch

local View       = moonview.View
local Model      = moonview.Model
local Collection = moonview.Collection
local Router     = moonview.Router

local ghEndpoint = "https://api.github.com"
local ghToken    = "?access_token=" .. require("moonhub.config").ghToken

coroutine.wrap(function()

    local router, projectSelectorView, commitsView, userView, userSelectorView

    projectSelectorView = View {
        target   = "#project-selector",
        template = "#project-selector-template",
        model    = Model {
            user   = nil,
            project = nil,
            currentBranch = "master",
            branches = Collection {}
        },
        events   = {
            ["click #go"] = function(self)
                self:update(true)
            end,
            ["change select[name=branches]"] = function(self)
                self:update()
            end,
            ["keydown input"] = function(self, _, event)
                if (event.key == "Enter") then
                    self:update()
                end
            end
        }
    }

    projectSelectorView.update = function(self, force)
        local nuser = q("input[name=user]").value
        nuser = #nuser > 0 and nuser or nil
        local nproject = q("input[name=project]").value
        nproject = #nproject > 0 and nproject or nil
        local nbranch = q("select[name=branches]").value
        nbranch = #nbranch > 0 and nbranch or nil

        if (nuser ~= self.model.user
            or nproject ~= self.model.project
            or nbranch ~= self.model.currentBranch
            or force) then
            self.model.user = nuser
            self.model.project = nproject
            self.model.currentBranch = nbranch or "master"

            coroutine.wrap(function ()
                local user = projectSelectorView.model.user
                local project = projectSelectorView.model.project
                local branch = projectSelectorView.model.currentBranch or "master"

                commitsView.model.commits = Collection(
                    fetchj(
                        ghEndpoint
                        .. "/repos/"
                        .. user
                        .. "/" .. project
                        .. "/commits"
                        .. ghToken
                        .. "&sha=" .. branch
                    )
                )

                local readme

                readme, self.model.branches = fetchj(
                    ghEndpoint
                        .. "/repos/"
                        .. user
                        .. "/"
                        .. project
                        .. "/readme"
                        .. ghToken
                        .. "&ref=" .. branch,
                    ghEndpoint
                        .. "/repos/"
                        .. user
                        .. "/"
                        .. project
                        .. "/branches"
                        .. ghToken
                )

                commitsView.model.readme = fetch(readme.download_url)
            end)()
        end
    end

    commitsView = View {
        target   = "#commits",
        template = "#commits-template",
        model    = Model {
            commits = Collection {},
            readme = nil
        }
    }

    userSelectorView = View {
        target   = "#project-selector",
        template = "#user-selector-template",
        model    = Model {
            user   = nil
        },
        events   = {
            ["click #go"] = function(self)
                self:update()
            end,
            ["keydown input"] = function(self, _, event)
                if (event.key == "Enter") then
                    self:update()
                end
            end
        }
    }

    userView = View {
        target   = "#commits",
        template = "#repos-template",
        model = Model {
            repos = Collection {}
        }
    }

    userSelectorView.update = function(self, force)
        local nuser = q("input[name=user]").value

        if (nuser ~= self.model.user or force) then
            self.model.user = nuser

            coroutine.wrap(function ()
                userView.model.repos = Collection(
                    fetchj(
                        ghEndpoint
                        .. "/users/"
                        .. userSelectorView.model.user
                        .. "/repos"
                        .. ghToken
                    )
                )
            end)()
        end
    end

    router = Router {
        ["/:user"] = function(user)
            userSelectorView.model.user = user

            userSelectorView:update(true)
        end,
        ["/:user/:project"] = function(user, project)
            projectSelectorView.model.user = user
            projectSelectorView.model.project = project

            projectSelectorView:update(true)
        end,
        ["/:user/:project/:branch"] = function(user, project, branch)
            projectSelectorView.model.user = user
            projectSelectorView.model.project = project
            projectSelectorView.model.currentBranch = branch

            projectSelectorView:update(true)
        end
    }

    userSelectorView:render()
    userView:render()

end)()
