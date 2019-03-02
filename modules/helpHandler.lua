local function base(client, message)
    return message.channel:send{embed = {
        color = 0x10525C,
        author = {
            name = client.user.username,
            icon_url = client.user:getAvatarURL()
        },
        title = "HolidayBot Help",
        description = "Commands list",
        fields = {{
            name = "`help`",
            value = "Shows this message."
        },
        {
            name = "`about`",
            value = "Shows information about the bot (invite, source, purpose, author, etc.)"
        },
        {
            name = "`settings`",
            value = "Displays current server-specific settings."
        },
        {
            name = "`ping`",
            value = "Pong!"
        },
        {
            name = "`stats`",
            value = "Shows bot statistics like uptime, lib versions, etc."
        },
        {
            name = "`h [region]`",
            value = "Displays holidays in the specified region or server region on command (if enabled)"
        },
        {
            name = "`set`",
            value = "Sets server-specific settings (Manage Server permission required), run `help set` for settings list and syntax."
        }},
        footer = {
            icon_url = message.author:getAvatarURL(),
            text = message.author.username
        }
    }}
end

local function set(client, message)
    return message.channel:send{embed = {
        color = 0x10525C,
        author = {
            name = client.user.username,
            icon_url = client.user:getAvatarURL()
        },
        title = "HolidayBot Help",
        description = "Commands list (`set`)",
        fields = {{
            name = "`set prefix <desiredPrefix>`",
            value = "Changes the prefix used on this server (default: `h[`)"
        },
        {
            name = "`set region <desiredRegion>`",
            value = "Changes the region to any valid tz/zoneinfo database region. See list [here](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones). This is used for the daily posting region, as well as the default region used when `h [region]` is run. By default, this will be the timezone associated with the server region."
        },
        {
            name = "`set adult <on|off>`",
            value = "Enables/disables content that may not be safe for viewing by children (default: `off`/`false`)"
        },
        {
            name = "`set daily <on|off>`",
            value = "Enables/disables the bot posting new holidays every midnight in the set region (default: `on`/`true`)"
        },
        {
            name = "`set dailyChannel <channelTag>`",
            value = "Sets the channel the daily holidays (if enabled) will be posted in. By default, this will either be any channel named `general` or the first channel the bot is able to send messages in."
        },
        {
            name = "`set command <on|off>`",
            value = "Enables/disables the ability for users to run `h [region]` to display holidays on command (default: `on`/`true`)"
        },
        {
            name = "`set reset`",
            value = "Resets this guild's settings to the default settings"
        }},
        footer = {
            icon_url = message.author:getAvatarURL(),
            text = message.author.username
        }
    }}
end

return {
    ["base"] = base,
    ["set"] = set
}