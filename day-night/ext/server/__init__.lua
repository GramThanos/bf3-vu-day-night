require('__shared/ticks')
require('__shared/net')

local server_started = os.clock()

local function updateHours()
    -- Server tracks only hours
    hours = ((os.clock() - server_started) * daytime_hour_change_per_second) + (days * 24)
end

local function broadcastHours()
    NetEvents:Broadcast(NetMessage.S2C_SYNC_DAYTIME, hours)
end


-- Record Ticks
local engine_update_timer = 0.0
Events:Subscribe('Engine:Update', function(dt)
    engine_update_timer = engine_update_timer + dt
    if engine_update_timer < server_update_daytime then
        return
    end
    engine_update_timer = engine_update_timer % server_update_daytime

    -- Update hours & days
    updateHours()
    -- Sync players
    broadcastHours()

    -- Print Debug info
    if print_ticks_daytime_info == true then
        local d = (hours - (hours % 24)) / 24
        local h = hours % 24
        print('Datetime : ' .. tostring(d) .. ' days ' .. tostring(h) .. ' hours')
    end
end)


Events:Subscribe('Level:Loaded', function(levelName, gameMode, round, roundsPerMap)
    if reset_days_hours_for_each_level == true then
        days = 1
        hours = start_hour
        if randomize_start_hour == true then
            hours = math.random(0, 23)
        end
    end
end)
