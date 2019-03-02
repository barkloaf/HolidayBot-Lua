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

return {
    getDefaultRegion = getDefaultRegion,
    getDefaultChannel = getDefaultChannel,
    readAll = readAll
}