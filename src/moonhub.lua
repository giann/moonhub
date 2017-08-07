package.path = "../lua_modules/share/lua/5.3/?.lua;../lua_modules/share/lua/5.3/?/init.lua"

local moonview = require("moonview")
local helpers  = require("moonview.helpers")
local Signal   = require("hump.signal")
local q        = helpers.q
local qall     = helpers.qall
local fetchj   = helpers.fetchj

local View       = moonview.View
local Model      = moonview.Model
local Collection = moonview.Collection

local ghEndpoint = "https://api.github.com"
local ghToken    = "?access_token=639ccc89c5d5b919733b25e90f3cee87a80c874d"

coroutine.wrap(function()

    local projectSelectorView, commitsView

    projectSelectorView = View {
        target   = "#project-selector",
        template = "#project-selector-template",
        model    = Model {
            user   = nil,
            project = nil
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

    projectSelectorView.update = function(self)
        local nuser = q("input[name=user]").value
        local nproject = q("input[name=project]").value

        if (nuser ~= self.model.user or nproject ~= self.model.project) then
            self.model.user = nuser
            self.model.project = nproject

            coroutine.wrap(function ()
                commitsView.model.commits = Collection(
                    fetchj(
                        ghEndpoint
                        .. "/repos/"
                        .. projectSelectorView.model.user
                        .. "/"
                        .. projectSelectorView.model.project
                        .. "/commits"
                        .. ghToken
                    )
                )
            end)()
        end
    end

    commitsView = View {
        target   = "#commits",
        template = "#commits-template",
        model    = Model {
            commits = Collection {}
        }
    }

    projectSelectorView:render()
    commitsView:render()

end)()
