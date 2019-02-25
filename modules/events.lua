local dbFile = require("./db")
local misc = require("./misc")
local fs = require("fs")
local commands = require("./commands")
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
    if message.author.bot==true then return end
    if not message.guild then return end
    local prefixLength = string.len(dbFile.getPrefix(message.guild.id))
    local prefixOnly = message.content:sub(1, prefixLength)
    if prefixOnly ~= dbFile.getPrefix(message.guild.id) then return end
    local prefixLengthPlus1 = string.len(dbFile.getPrefix(message.guild.id)) + 1
    local command = message.content:sub(prefixLengthPlus1)
    local args = command:split(" ")
    
    if commands["".. args[1]] == nil then return end
    
    commands["".. args[1]](client, message, args)
end
local function guildCreate(guild) end
local function guildUpdate(guild) end
local function guildDelete(guild) end
local function ready() end

return {
    messageCreate = messageCreate,
    guildCreate = guildCreate,
    guildUpdate = guildUpdate,
    guildDelete = guildDelete,
    ready = ready
}