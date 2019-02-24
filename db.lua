local function getDefaultChannel(guild)
    local role = guild.defaultRole
    local global = role:getPermissions()
    return guild.textChannels:toArray("position", function(ch)
        return ch:getPermissionOverwriteFor(role):getAllowedPermissions():union(global):has(0x00000800)
    end)[1]
end

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

local rethink = require('luvit-reql')
local r = rethink.connect()

local function createGuild(guild)
    return r.reql().db("HolidayBot_Lua").table("guilds").insert({
        id = guild.id,
        guildname = guild.name,
        prefix = "h]",
        region = getDefaultRegion(guild),
        adult = false,
        daily = true,
        dailyChannel = getDefaultChannel(guild).id,
        command = true
    }).run()
end

local function updatePrefix(guildID, newPrefix)
    return r.reql().db("HolidayBot_Lua").table("guilds").get(guildID).update({
        prefix = newPrefix
    }).run()
end

local function updateRegion(guildID, region) 
    return r.reql().db("HolidayBot_Lua").table("guilds").get(guildID).update({
        region = region
    }).run();
end

local function updateAdult(guildID, newAdult) 
    return r.reql().db("HolidayBot_Lua").table("guilds").get(guildID).update({
        adult = newAdult
    }).run();
end

local function updateDaily(guildID, newDaily) 
    return r.reql().db("HolidayBot_Lua").table("guilds").get(guildID).update({
        daily = newDaily
    }).run();
end

local function updateDailyChannel(guildID, newDailyChannel) 
    return r.reql().db("HolidayBot_Lua").table("guilds").get(guildID).update({
        dailyChannel = newDailyChannel
    }).run();
end

local function updateCommand(guildID, newCommand) 
    return r.reql().db("HolidayBot_Lua").table("guilds").get(guildID).update({
        command = newCommand
    }).run();
end

local function updateGuildName(guildID, newGuildName) 
    return r.reql().db("HolidayBot_Lua").table("guilds").get(guildID).update({
        guildname = newGuildName
    }).run();
end

return {
    createGuild = createGuild,
    updatePrefix = updatePrefix,
    updateRegion = updateRegion,
    updateAdult = updateAdult,
    updateDaily = updateDaily,
    updateDailyChannel = updateDailyChannel,
    updateCommand = updateCommand,
    updateGuildName = updateGuildName
}