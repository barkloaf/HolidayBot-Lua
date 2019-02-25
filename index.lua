coroutine.wrap(function()
local discordia = require('discordia')
local client = discordia.Client()
discordia.extensions()
local json = require("json")
local dbFile = require("./modules/db")
local fs = require("fs")
local events = require("./modules/events")

local function readAll(file)
    local f = assert(io.open(file, "rb"))
    local content = f:read("*all")
    f:close()
    return content
end
local config = json.decode(readAll("config.json"))

client:on("messageCreate", events.messageCreate(client))
client:on("guildCreate", events.guildCreate(client))
client:on("guildUpdate", events.guildUpdate(client))
client:on("guildDelete", events.guildDelete(client))
client:on("ready", events.ready)

client:run("Bot " .. config["token"])
end)()