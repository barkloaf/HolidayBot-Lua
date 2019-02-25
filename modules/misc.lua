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

return {
    getDefaultRegion = getDefaultRegion
}