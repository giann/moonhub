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

local githubEndpoint = "https://api.github.com"

coroutine.wrap(function()
    local m = Model {
        commits = Collection(fetchj(githubEndpoint .. "/repos/giann/moonview/commits"))
    }

    local v = View {
        target   = "#app",
        template = "#commits-template",
        model    = m,
    }

    v:render()
end)()
