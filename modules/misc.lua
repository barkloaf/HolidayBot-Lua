local discordia = require("discordia")

local zones = {
    ["brazil"] = 'America/Sao_Paulo',
    ["us-west"] = 'America/Los_Angeles',
    ["japan"] = 'Asia/Tokyo',
    ["singapore"] = 'Asia/Singapore',
    ["eu-central"] = 'Europe/Berlin',
    ["hongkong"] = 'Asia/Hong_Kong',
    ["us-south"] = 'America/Chicago',
    ["southafrica"] = 'Africa/Johannesburg',
    ["us-central"] = 'America/Chicago',
    ["london"] = 'Europe/London',
    ["us-east"] = 'America/Toronto',
    ["sydney"] = 'Australia/Sydney',
    ["eu-west"] = 'Europe/Paris',
    ["amsterdam"] = 'Europe/Amsterdam',
    ["frankfurt"] = 'Europe/Berlin',
    ["russia"] = 'Europe/Moscow',
}
local function getDefaultRegion(guild)
    return zones[guild.region] or 'UTC'
end

local function getDefaultChannel(guild)
    local client = guild.client
    local role = guild.defaultRole
    local global = role:getPermissions()
    return guild.textChannels:toArray("position", function(ch)
        return ch:getPermissionOverwriteFor(role):getAllowedPermissions():union(global):has(0x00000800)
    end)[1]
end

local function readAll(file)
    local f = assert(io.open(file, "rb"))
    local content = f:read("*all")
    f:close()
    return content
end

local function cmdHook(client, content, type, subType, assocUser, assocGuild, assocTz)
    local json = require("json")
    local config = json.decode(readAll("config.json"))
    if type == "succ" then
        client._api:executeWebhook(config["whID"], config["whToken"],{embeds = {{
            color = 0x10525C,
            author = {
                name = "Success",
                icon_url = client.user:getAvatarURL()
            },
            title = ""..assocUser.tag.." (ID: "..assocUser.id..")",
            description = "Ran `"..content.."` in __"..assocGuild.name.."__ (ID: "..assocGuild.id..")",
            timestamp = discordia.Date():toISO()
        }}})
    elseif type == "fail" then
        client._api:executeWebhook(config["whID"], config["whToken"],{embeds = {{
            color = 0xc6373e,
            author = {
                name = "Fail ["..subType.."]",
                icon_url = client.user:getAvatarURL()
            },
            title = ""..assocUser.tag.." (ID: "..assocUser.id..")",
            description = "Ran `"..content.."` in __"..assocGuild.name.."__ (ID: "..assocGuild.id..")",
            timestamp = discordia.Date():toISO()
        }}})
    elseif type == "dp" then
        if subType == "succ" then
            client._api:executeWebhook(config["whID"], config["whToken"],{embeds = {{
                color = 0x3a1cbb,
                author = {
                    name = "Daily Posting",
                    icon_url = client.user:getAvatarURL()
                },
                title = "Successfuly daily posted in __"..assocGuild.name.."__ (ID: "..assocGuild.id..")",
                description = "tz: __"..assocTz.."__",
                timestamp = discordia.Date():toISO()
            }}})
        elseif subType == "fail" then
            client._api:executeWebhook(config["whID"], config["whToken"],{embeds = {{
                color = 0xc6373e,
                author = {
                    name = "Daily Posting",
                    icon_url = client.user:getAvatarURL()
                },
                title = "Failure in __"..assocGuild.name.."__ (ID: "..assocGuild.id..") tz: "..assocTz,
                description = content,
                timestamp = discordia.Date():toISO()
            }}})
        end
    elseif type == "info" then
        if subType == "join" then
            client._api:executeWebhook(config["whID"], config["whToken"],{embeds = {{
                color = 0x10525C,
                author = {
                    name = "Info",
                    icon_url = client.user:getAvatarURL()
                },
                title = "New guild: `"..assocGuild.name.."` (ID: "..assocGuild.id..")",
                timestamp = discordia.Date():toISO()
            }}})
        elseif subType == "leave" then
            client._api:executeWebhook(config["whID"], config["whToken"],{embeds = {{
                color = 0x10525C,
                author = {
                    name = "Info",
                    icon_url = client.user:getAvatarURL()
                },
                title = "Removed from Guild: `"..assocGuild.name.."` (ID: "..assocGuild.id..")",
                timestamp = discordia.Date():toISO()
            }}})
        elseif subType == "start" then
            client._api:executeWebhook(config["whID"], config["whToken"],{embeds = {{
                color = 0x10525C,
                author = {
                    name = "Info",
                    icon_url = client.user:getAvatarURL()
                },
                title = "Bot Started!",
                timestamp = discordia.Date():toISO()
            }}})
        elseif subType == "nameChange" then
            client._api:executeWebhook(config["whID"], config["whToken"],{embeds = {{
                color = 0x10525C,
                author = {
                    name = "Info",
                    icon_url = client.user:getAvatarURL()
                },
                title = "Guild `"..content.."` (ID: "..assocGuild.id..") has changed their name to __"..assocGuild.name.."__",
                timestamp = discordia.Date():toISO()
            }}})
        elseif subType == "channelDelete" then
            client._api:executeWebhook(config["whID"], config["whToken"],{embeds = {{
                color = 0x10525C,
                author = {
                    name = "Info",
                    icon_url = client.user:getAvatarURL()
                },
                title = "Guild `"..assocGuild.name.."` (ID: "..assocGuild.id..") has deleted their daily channel. Resetting to __"..content.."__",
                timestamp = discordia.Date():toISO()
            }}})
        end
    end
end

return {
    getDefaultRegion = getDefaultRegion,
    getDefaultChannel = getDefaultChannel,
    readAll = readAll,
    cmdHook = cmdHook
}