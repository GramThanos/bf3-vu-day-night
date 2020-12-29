require('__shared/ticks')
require('__shared/net')

local server_started = os.clock()

local function updateHours()
    -- Server tracks only hours
    hours = (os.clock() - server_started) * daytime_hour_change_per_second
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

    updateHours()
    broadcastHours()

    if print_ticks_daytime_info == true then
        local d = (hours - (hours % 24)) / 24
        local h = hours % 24
        print('Datetime : ' .. tostring(d) .. ' days ' .. tostring(h) .. ' hours')
    end
end)
