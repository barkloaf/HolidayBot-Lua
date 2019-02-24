coroutine.wrap(function()
local discordia = require('discordia')
local client = discordia.Client()
discordia.extensions()
local json = require("json")
local dbFile = require("./db")

local function readAll(file)
    local f = assert(io.open(file, "rb"))
    local content = f:read("*all")
    f:close()
    return content
end
local config = json.decode(readAll("config.json"))

client:on('guildCreate', function(guild)
    dbFile.createGuild(guild);
end)
client:on('messageCreate', function(message)
    local prefixDBResult = r.reql().db("HolidayBot_Lua").table("guilds").get(message.guild.id).getField("prefix").run()
    if (message.content == "" .. prefixDBResult .. "ping") then
        message:reply("pong")
	end
end)

client:run("Bot " .. config["token"])
end)()