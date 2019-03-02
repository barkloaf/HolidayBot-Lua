local discordia = require("discordia")
local Date = discordia.Date
local dbFile = require("./db")
local misc = require("./misc")
local json = require("json")
local config = json.decode(misc.readAll("config.json"))
local envir = setmetatable({
    require = require,
    discordia = discordia,
}, {__index = _G})

local function ping(client, message)
    message.channel:send{embed = {
        color = 0x10525C,
        author = {
            name = client.user.username,
            icon_url = client.user:getAvatarURL()
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
    local setHandler = require("./setHandler")
    if not message.member:hasPermission(0x00000020) then
        return message.channel:send{embed = {
            color = 0xc6373e,
            author = {
                name = client.user.username,
                icon_url = client.user:getAvatarURL()
            },
            title = "Error!",
            description = "Manage Server permission required for `set`.",
            footer = {
                icon_url = message.author:getAvatarURL(),
                text = message.author.username
            }
        }}
    end
    if setHandler["".. args[2]] == nil or args[2] == nil then
        return message.channel:send{embed = {
            color = 0xc6373e,
            author = {
                name = client.user.username,
                icon_url = client.user:getAvatarURL()
            },
            title = "Error!",
            description = "(`set`): Setting not recognized.",
            footer = {
                icon_url = message.author:getAvatarURL(),
                text = message.author.username
            }
        }}
    end
    setHandler["".. args[2]](client, message, args)

    return message.channel:send{embed = {
        color = 0x10525C,
        author = {
            name = client.user.username,
            icon_url = client.user:getAvatarURL()
        },
        title = "Guild settings changed!",
        description = "Run `settings` to view all settings.",
        footer = {
            icon_url = message.author:getAvatarURL(),
            text = message.author.username
        }
    }}
end

local function settings(client, message, args)
    return message.channel:send{embed = {
        color = 0x10525C,
        author = {
            name = client.user.username,
            icon_url = client.user:getAvatarURL()
        },
        title = "Current guild settings for".. message.guild.name,
        description = "Run `help set` for more information",
        thumbnail = {url = message.guild.iconURL},
        fields = {{
            name = "Prefix (default: `h[`):",
            value = dbFile.getPrefix(message.guild.id)
        },
        {
            name = "Region (default: `".. misc.getDefaultRegion(message.guild).. "`):",
            value = dbFile.getRegion(message.guild.id)
        },
        {
            name = "Adult (default: `false`):",
            value = dbFile.getAdult(message.guild.id)
        },
        {
            name = "Daily Posting (default: `true`):",
            value = dbFile.getDaily(message.guild.id)
        },
        {
            name = "Daily Posting Channel (if enabled) (default: `".. misc.getDefaultChannel(message.guild).id.. "`):",
            value = "<#".. dbFile.getDailyChannel(message.guild.id).. ">"
        },
        {
            name = "Holiday Command (default: `true`):",
            value = dbFile.getCommand(message.guild.id)
        }},
        footer = {
            icon_url = message.author:getAvatarURL(),
            text = message.author.username
        }
    }}
end

local function die(client, message, args)
    if(message.author.id == config["ownerID"]) then
        message.channel:send{embed = {
            color = 0x10525C,
            author = {
                name = client.user.username,
                icon_url = client.user:getAvatarURL()
            },
            title = "Shutting Down...",
            footer = {
                icon_url = message.author:getAvatarURL(),
                text = message.author.username
            }
        }}
        client:stop()
    else
        return message.channel:send{embed = {
            color = 0xc6373e,
            author = {
                name = client.user.username,
                icon_url = client.user:getAvatarURL()
            },
            title = "Error!",
            description = "You do not have permission to run `die`",
            footer = {
                icon_url = message.author:getAvatarURL(),
                text = message.author.username
            }
        }}
    end
end

local function eval(client, message, args, command)
    if(message.author.id == config["ownerID"]) then
        local joinedArgs = table.concat(args, " ")
        local code = joinedArgs:sub(6)

        envir.message = message
        envir.channel = message.channel
        envir.guild = message.guild
        envir.client = message.client
   
        local function preEval()
            local evaled, err = load("".. code, "eval", "t", envir)()
        end
        local success, err = pcall(preEval)
        if not success then
            return message.channel:send{embed = {
                color = 0x10525C,
                title = "❌ Eval Failed",
                fields = {{
                    name = "Input",
                    value = "```lua\n".. code.. "\n```"
                },
                {
                    name = "Output",
                    value = err
                }
                }
            }}
        else
            p(preEval())
            local output = "```lua\n".. preEval().. "\n```"
            if(string.len(output) > 1028) then output = "```lua\noverflow```" end
            return message.channel:send{embed = {
                color = 0x10525c,
                title = "✅ Eval Successful",
                fields = {{
                    name = "Input",
                    value = "```lua\n".. code.. "\n```"
                },
                {
                    name = "Output",
                    value = output
                }}
            }}
        end

    else return message.channel:send{embed = {
        color = 0xc6373e,
        author = {
            name = client.user.username,
            icon_url = client.user:getAvatarURL()
        },
        title = "Error!",
        description = "You do not have permission to run `eval`",
        footer = {
            icon_url = message.author:getAvatarURL(),
            text = message.author.username
        }
    }}
    end
end

local function help(client, message, args)
    local helpHandler = require("./helpHandler")
    if args[2] == nil then args[2] = "base" end

    if helpHandler[args[2]] == nil then
        return message.channel:send{embed = {
            color = 0xc6373e,
            author = {
                name = client.user.username,
                icon_url = client.user:getAvatarURL()
            },
            title = "Error!",
            description = "Syntax (`help`): see `help`",
            footer = {
                icon_url = message.author:getAvatarURL(),
                text = message.author.username
            }
        }}
    end

    helpHandler["".. args[2]](client, message)
end

return {
    ["ping"] = ping,
    ["set"] = set,
    ["settings"] = settings,
    ["die"] = die,
    ["eval"] = eval,
    ["help"] = help,
}