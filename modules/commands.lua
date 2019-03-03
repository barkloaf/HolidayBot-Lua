local discordia = require("discordia")
local Date = discordia.Date
local dbFile = require("./db")
local misc = require("./misc")
local json = require("json")
local config = json.decode(misc.readAll("config.json"))
local envir = setmetatable({
    require = require,
    discordia = discordia,
    dbFile = dbFile
}, {__index = _G})

local function ping(client, message)
    local reply = message:reply{embed = {
        color = 0x10525C,
        author = {
            name = client.user.username,
            icon_url = client.user:getAvatarURL()
        },
        title = "Pong!",
        description = "Calculating...",
        footer = {
            icon_url = message.author:getAvatarURL(),
            text = message.author.username
        }
    }}
    local ping = math.abs(math.round((reply.createdAt - message.createdAt)*1000))
    reply:setEmbed{
        color = 0x10525C,
        author = {
            name = client.user.username,
            icon_url = client.user:getAvatarURL()
        },
        title = "Pong!",
        description = "**Message Latency:** ".. ping.. " ms",
        footer = {
            icon_url = message.author:getAvatarURL(),
            text = message.author.username
        }
    }
end

local function set(client, message, args)
    local setHandler = require("./setHandler")
    if not message.member:hasPermission(0x00000020) and config["ownerID"] ~= message.author.id then
        misc.cmdHook(client, message.content, "fail", "Permission", message.author, message.guild, nil)
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
        misc.cmdHook(client, message.content, "fail", "Syntax", message.author, message.guild, nil)
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
        misc.cmdHook(client, message.content, "fail", "Permission", message.author, message.guild, nil)
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
   
        local f, loadErr = load(code, "eval", "t", envir)

        if not f then
            misc.cmdHook(client, message.content, "fail", "Eval Load Error", message.author, message.guild, nil)
            local stringedError = tostring(loadErr)
            return message.channel:send{embed = {
                color = 0x10525C,
                title = "❌ Eval Failed",
                fields = {{
                    name = "Input",
                    value = "```lua\n".. code.. "\n```"
                },
                {
                    name = "Output",
                    value = stringedError
                }
                }
            }}
        else
            local success, output = pcall(f)
            if success then
                local newOutput = "```lua\n".. tostring(output).. "\n```"
                if(string.len(newOutput) > 1028) then newOutput = "```lua\noverflow```" end
                return message.channel:send{embed = {
                    color = 0x10525c,
                    title = "✅ Eval Successful",
                    fields = {{
                        name = "Input",
                        value = "```lua\n".. code.. "\n```"
                    },
                    {
                        name = "Output",
                        value = newOutput
                    }}
                }}
            else
                misc.cmdHook(client, message.content, "fail", "Eval Runtime Error", message.author, message.guild, nil)
                local stringedError = tostring(output)
                return message.channel:send{embed = {
                    color = 0x10525C,
                    title = "❌ Eval Failed",
                    fields = {{
                        name = "Input",
                        value = "```lua\n".. code.. "\n```"
                    },
                    {
                        name = "Output",
                        value = stringedError
                    }
                    }
                }}
            end
        end

    else
        misc.cmdHook(client, message.content, "fail", "Permission", message.author, message.guild, nil)
        return message.channel:send{embed = {
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
        misc.cmdHook(client, message.content, "fail", "Syntax", message.author, message.guild, nil)
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

local function about(client, message)
    return message.channel:send{embed = {
        color = 0x10525C,
        author = {
            name = client.user.username,
            icon_url = client.user:getAvatarURL()
        },
        title = "Hello, my name is HolidayBot Lua!",
        description = "I am a port of HolidayBot created with Discordia that spits out real holidays that you may have never heard of before. All holidays are grabbed from [checkiday.com](https://checkiday.com)",
        thumbnail = {url = client.user:getAvatarURL()},
        fields = {{
            name = "Check out the source",
            value = "[GitHub](https://github.com/barkloaf/HolidayBot-Lua)"
        },
        {
            name = "Feedback?",
            value = "Feel free to contact the bot owner, <@".. config.ownerID.. "> :3"
        }},
        footer = {
            icon_url = message.author:getAvatarURL(),
            text = message.author.username
        }
    }}
end

local function stats(client, message)
    local botUptime = tostring(discordia.storage.uptime:getTime():toString())
    local process = require("process")
    local luvi = require('luvi')
    local luviVersion = luvi.bundle.action("package.lua", dofile).version
    return message.channel:send{embed = {
        color = 0x10525C,
        author = {
            name = client.user.username,
            icon_url = client.user:getAvatarURL()
        },
        title = "HolidayBot Lua Stats",
        fields = {{
            name = "# of guilds",
            value = client.guilds:count()
        },
        {
            name = "# of users",
            value = client.users:count()
        },
        {
            name = "Discordia Version",
            value = discordia.package.version
        },
        {
            name = "Luvit Version",
            value = luviVersion
        },
        {
            name = "Memory Usage",
            value = ""..tostring((process.globalProcess().memoryUsage().heapUsed / 1024 / 1024)):gsub("%.(%d%d)%d+",".%1").. " MiB"
        },
        {
            name = "Uptime",
            value = botUptime
        }},
        footer = {
            icon_url = message.author:getAvatarURL(),
            text = message.author.username
        }
    }}
end

return {
    ["ping"] = ping,
    ["set"] = set,
    ["settings"] = settings,
    ["die"] = die,
    ["eval"] = eval,
    ["help"] = help,
    ["about"] = about,
    ["stats"] = stats,
}