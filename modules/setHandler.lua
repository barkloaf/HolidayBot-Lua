local dbFile = require("./db")
local misc = require("./misc")

local function setPrefix(client, message, args)
    dbFile.updatePrefix(message.guild.id, args[3])
end

local function setAdult(client, message, args)
    if args[3] == "on" or args[3] == "true" then dbFile.updateAdult(message.guild.id, true)
    elseif args[3] == "on" or args[3] == "false" then dbFile.updateAdult(message.guild.id, false)
    else
        return message.channel:send{embed = {
            color = 0xc6373e,
            author = {
                name = client.user.username,
                icon_url = client.user:getAvatarURL()
            },
            title = "Error!",
            description = "Syntax (`set adult`): `set adult <on|off>`",
            footer = {
                icon_url = message.author:getAvatarURL(),
                text = message.author.username
            }
        }}
    end
end

local function setDaily(client, message, args)
    if args[3] == "on" or args[3] == "true" then dbFile.updateDaily(message.guild.id, true)
    elseif args[3] == "off" or args[3] == "false" then dbFile.updateDaily(message.guild.id, false)
    else
        return message.channel:send{embed = {
            color = 0xc6373e,
            author = {
                name = client.user.username,
                icon_url = client.user:getAvatarURL()
            },
            title = "Error!",
            description = "Syntax (`set daily`): `set daily <on|off>`",
            footer = {
                icon_url = message.author:getAvatarURL(),
                text = message.author.username
            }
        }}
    end
end

local function setCommand(client, message, args)
    if args[3] == "on" or args[3] == "true" then dbFile.updateCommand(message.guild.id, true)
    elseif args[3] == "on" or args[3] == "false" then dbFile.updateCommand(message.guild.id, false)
    else
        return message.channel:send{embed = {
            color = 0xc6373e,
            author = {
                name = client.user.username,
                icon_url = client.user:getAvatarURL()
            },
            title = "Error!",
            description = "Syntax (`set command`): `set command <on|off>`",
            footer = {
                icon_url = message.author:getAvatarURL(),
                text = message.author.username
            }
        }}
    end
end

local function setRegion(client, message, args)
    --placeholder
end

local function setDailyChannel(client, message, args)
    if message.mentionChannels[1] then
        return message.channel:send{embed = {
            color = 0xc6373e,
            author = {
                name = client.user.username,
                icon_url = client.user:getAvatarURL()
            },
            title = "Error!",
            description = "Syntax (`set dailyChannel`): `set dailyChannel <channelTag>`",
            footer = {
                icon_url = message.author:getAvatarURL(),
                text = message.author.username
            }
        }}
    end
    if not message.guild.me:hasPermisssion(message.mentionChannels[1].id, 0x00000800) then
        return message.channel:send{embed = {
            color = 0xc6373e,
            author = {
                name = client.user.username,
                icon_url = client.user:getAvatarURL()
            },
            title = "Error!",
            description = "No permission to send messages in mentioned channel.",
            footer = {
                icon_url = message.author:getAvatarURL(),
                text = message.author.username
            }
        }}
    end
    dbFile.updateDailyChannel(message.guild.id, message.mentionChannels[1].id)
end

local function reset(client, message, args)
    dbFile.updatePrefix(message.guild.id, "h[")
    dbFile.updateRegion(message.guild.id, misc.getDefaultRegion(message.guild))
    dbFile.updateAdult(message.guild.id, false)
    dbFile.updateDaily(message.guild.id, true)
    dbFile.updateDailyChannel(message.guild.id, misc.getDefaultChannel(message.guild).id)
    dbFile.updateCommand(message.guild.id, true)
end

return {
    ["prefix"] = setPrefix,
    ["adult"] = setAdult,
    ["daily"] = setDaily,
    ["command"] = setCommand,
    ["region"] = setRegion,
    ["dailyChannel"] = setDailyChannel,
    ["dailychannel"] = setDailyChannel,
    ["reset"] = reset
}