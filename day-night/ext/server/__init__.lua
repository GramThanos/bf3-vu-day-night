require('__shared/ticks')
require('__shared/net')
require('__shared/tools')
require('updateCheck')

local server_day_night_cycle_seconds = 0.0
local engine_update_timer = 0.0

local function broadcastDayNightCycleSeconds()
	print("[Broadcast] Date: " .. tostring(server_day_night_cycle_seconds) .. " sec")
    NetEvents:Broadcast(NetMessage.S2C_SYNC_DAYTIME, server_day_night_cycle_seconds)
end

-- Record Ticks
Events:Subscribe('Engine:Update', function(dt)

	if day_night_cycle_enabled == false then
		return
	end
    engine_update_timer = engine_update_timer + dt
    server_day_night_cycle_seconds = server_day_night_cycle_seconds + dt
    
	-- Print Debug info
	if print_ticks_daytime_info == true then
		-- Update hours & days
		local t_days = nil
		local t_hours = nil
		t_days, t_hours = getDaysHours(server_day_night_cycle_seconds)
		
		if hours ~= t_hours or days ~= t_days then
			days = t_days
			hours = t_hours
			print('Datetime : ' .. tostring(days) .. ' days ' .. tostring(hours) .. ' hours')
		end
    end
	
	-- Check if it is time to send a client update (to ensure client sync)
	if engine_update_timer < server_update_daytime then
        return
    end
    engine_update_timer = 0.0
    
    -- Sync players
    broadcastDayNightCycleSeconds()
	
end)


Events:Subscribe('Level:Loaded', function(levelName, gameMode, round, roundsPerMap)
    if reset_days_hours_for_each_level == true then
		days = 0
        hours = start_hour % 24
        if randomize_start_hour == true then
            hours = math.random(0, 23)
        end
		server_day_night_cycle_seconds = hours / 24 * server_day_night_cycle_seconds
    end
end)

Events:Subscribe('Player:Authenticated', function(name, playerGuid, ipAddress, accountGuid)
	print("[Authenticated Broadcast] Date: " .. tostring(server_day_night_cycle_seconds) .. " sec")
    NetEvents:Broadcast(NetMessage.S2C_SYNC_DAYTIME, server_day_night_cycle_seconds)
end)