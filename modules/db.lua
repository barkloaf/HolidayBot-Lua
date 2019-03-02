local misc = require("./misc")
local rethink = require('luvit-reql')
local r = rethink.connect()

local function createGuild(guild)
    return r.reql().db("HolidayBot_Lua").table("guilds").insert({
        id = guild.id,
        guildname = guild.name,
        prefix = "h[",
        region = misc.getDefaultRegion(guild),
        adult = false,
        daily = true,
        dailyChannel = misc.getDefaultChannel(guild).id,
        command = true
    }).run()
end

local function getGuildName(guildID)
    return r.reql().db("HolidayBot_Lua").table("guilds").get(guildID).getField("guildname").run()
end

local function getPrefix(guildID)
    return r.reql().db("HolidayBot_Lua").table("guilds").get(guildID).getField("prefix").run()
end

local function getRegion(guildID)
    return r.reql().db("HolidayBot_Lua").table("guilds").get(guildID).getField("region").run()
end

local function getAdult(guildID)
    return r.reql().db("HolidayBot_Lua").table("guilds").get(guildID).getField("adult").run()
end

local function getDaily(guildID)
    return r.reql().db("HolidayBot_Lua").table("guilds").get(guildID).getField("daily").run()
end

local function getDailyChannel(guildID)
    return r.reql().db("HolidayBot_Lua").table("guilds").get(guildID).getField("dailyChannel").run()
end

local function getCommand(guildID)
    return r.reql().db("HolidayBot_Lua").table("guilds").get(guildID).getField("command").run()
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
    getGuildName = getGuildName,
    getPrefix = getPrefix,
    getRegion = getRegion,
    getAdult = getAdult,
    getDaily = getDaily,
    getDailyChannel = getDailyChannel,
    getCommand = getCommand,
    updatePrefix = updatePrefix,
    updateRegion = updateRegion,
    updateAdult = updateAdult,
    updateDaily = updateDaily,
    updateDailyChannel = updateDailyChannel,
    updateCommand = updateCommand,
    updateGuildName = updateGuildName
}