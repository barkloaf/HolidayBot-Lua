local dbFile = require("./db")
local misc = require("./misc")
local fs = require("fs")
local commands = require("./commands")
local discordia = require('discordia')
local dbFile = require("./db")

function string:split( inSplitPattern, outResults )
    if not outResults then
      outResults = { }
    end
    local theStart = 1
    local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
    while theSplitStart do
      table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
      theStart = theSplitEnd + 1
      theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
    end
    table.insert( outResults, string.sub( self, theStart ) )
    return outResults
end

local function messageCreate(message)
    local client = message.client
    if message.author.bot==true then return end
    if not message.guild then return end
    local prefixLength = string.len(dbFile.getPrefix(message.guild.id))
    local prefixOnly = message.content:sub(1, prefixLength)
    if prefixOnly ~= dbFile.getPrefix(message.guild.id) then return end
    local prefixLengthPlus1 = string.len(dbFile.getPrefix(message.guild.id)) + 1
    local command = message.content:sub(prefixLengthPlus1)
    local args = command:split(" ")
    if commands["".. args[1]] == nil then return end

    commands["".. args[1]](client, message, args, command)
    
    misc.cmdHook(client, message.content, "succ", nil, message.author, message.guild, nil)
end
local function guildCreate(guild)
    local client = guild.client
    dbFile.createGuild(guild)
    misc.cmdHook(client, nil, "info", "join", nil, guild, nil)
end
local function guildUpdate(guild)
    if dbFile.getGuildName(guild.id) ~= guild.name then
        local client = guild.client
        misc.cmdHook(client, dbFile.getGuildName(guild.id), "info", "nameChange", nil, guild, nil)
        dbFile.updateGuildName(guild.id, guild.name)
    end
end
local function guildDelete(guild)
    local client = guild.client
    misc.cmdHook(client, nil, "info", "leave", nil, guild, nil)
end
local function channelDelete(channel)
    if channel.id == dbFile.getDailyChannel(channel.guild.id) then
        local client = channel.client
        misc.cmdHook(client, misc.getDefaultChannel(channel.guild).id, "info", "channelDelete", nil, channel.guild, nil)
        dbFile.updateDailyChannel(channel.id, misc.getDefaultChannel(channel.guild).id)
    end
end

return {
    messageCreate = messageCreate,
    guildCreate = guildCreate,
    guildUpdate = guildUpdate,
    guildDelete = guildDelete,
    channelDelete = channelDelete
}