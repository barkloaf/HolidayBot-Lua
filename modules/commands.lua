local discordia = require("discordia")
local Date = discordia.Date

local function ping(client, message)
    local discordia = require("discordia")
    local Date = discordia.Date
    message.channel:send{embed = {
        color = 0x10525C,
        author = {
            name = "HolidayBot",
            icon_url = "https://www.lua.org/manual/5.3/logo.gif"
        },
        title = "Pong!",
        description = (Date() - Date.fromSnowflake(message.id)):toString(),
        footer = {
            icon_url = message.author:getAvatarURL(),
            text = message.author.username
        }
    }}
end

local function set(client, message, args)
    local setHandler = require("setHandler")
    if setHandler["".. args[2]] == nil then
        return message.channel:send{embed = {
            color = 0xc6373e,
            author = {
                name = "HolidayBot",
                icon_url = "https://www.lua.org/manual/5.3/logo.gif"
            },
            title = "Pong!",
            description = (Date() - Date.fromSnowflake(message.id)):toString(),
            footer = {
                icon_url = message.author:getAvatarURL(),
                text = message.author.username
            }
        }}
    end
end

return {
    ["ping"] = ping
}