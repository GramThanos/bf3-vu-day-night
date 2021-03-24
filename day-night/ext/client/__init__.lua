require('__shared/ticks')
require('__shared/net')
require('__shared/tools')
require('ui')
require('night_preset')
require('interchangable')

local client_day_night_cycle_seconds = 0

-- Level was loaded
Events:Subscribe('Level:Loaded', function()
	-- level = SharedUtils:GetLevelName()
	Night()
end)

-- Record Ticks
local engine_update_timer = 0.0
Events:Subscribe('Engine:Update', function(dt)
    engine_update_timer = engine_update_timer + dt
	client_day_night_cycle_seconds = client_day_night_cycle_seconds + dt
	
	-- Limit VE changes
    if engine_update_timer < client_update_environment then
        return
    end
    engine_update_timer = 0.0
	
	-- Offset seconds to 0:00 AM
	local seconds = client_day_night_cycle_seconds % day_night_cycle_duration_in_seconds

	-- Offset seconds (0 is the middle of the night, but it should be the start of the night)
	--seconds = seconds + pure_night_duration_sec / 2
	
	local factor = nil
	
	-- Check if it is night
	if seconds < pure_night_duration_sec / 2 then
		factor = 1.0
	
	-- Check if it is night -> day
	elseif seconds < day_night_cycle_duration_in_seconds / 2 - pure_day_duration_sec / 2 then
		factor = 1.0 - (seconds - pure_night_duration_sec / 2) / (day_night_cycle_duration_in_seconds / 2 - pure_day_duration_sec / 2 - pure_night_duration_sec / 2)
		
	-- Check if it is day
	elseif seconds < day_night_cycle_duration_in_seconds / 2 + pure_day_duration_sec / 2 then
		factor = 0.001
		
	-- Check if it is day -> night
	elseif seconds < day_night_cycle_duration_in_seconds - pure_night_duration_sec / 2 then
		factor = (seconds - day_night_cycle_duration_in_seconds / 2 - pure_day_duration_sec / 2) / (day_night_cycle_duration_in_seconds - pure_night_duration_sec / 2 - day_night_cycle_duration_in_seconds / 2 - pure_day_duration_sec / 2)
	
	-- Check if it is night
	else
		factor = 1.0
	end
	
    -- Update environment lighting
	update_night_visibility(factor)
	
	-- Update UI indicators
    local t_days = nil
	local t_hours = nil
	t_days, t_hours = getFloatDaysHours(client_day_night_cycle_seconds)
	
	WebUI:ExecuteJS('window.update(' .. tostring(t_days) .. ', ' .. tostring(t_hours) .. ');')
	t_hours = math.floor(t_hours)
		
    -- Update hours & days
    
	if hours ~= t_hours or days ~= t_days then
        days = t_days
        hours = t_hours
		
		
		-- Print Debug info
		if print_ticks_daytime_info == true then
			print('Datetime : ' .. tostring(days) .. ' days ' .. tostring(hours) .. ' hours' .. ' -> ' .. tostring(factor))
		end
    end
	

end)

-- Listen to sync from server
NetEvents:Subscribe(NetMessage.S2C_SYNC_DAYTIME, function(server_day_night_cycle_seconds)
    client_day_night_cycle_seconds = server_day_night_cycle_seconds
	
	-- Update hours and days from server
	days, hours = getDaysHours(server_day_night_cycle_seconds)

    -- Print Debug info
    if print_ticks_daytime_info == true then
        print('Server Datetime Sync : ' .. tostring(days) .. ' days ' .. tostring(hours) .. ' hours')
    end
end)

-- Load UI
Events:Subscribe('Extension:Loaded', function()
    WebUI:Init()
    WebUI:ExecuteJS('window.settings({days: ' .. tostring(show_days) .. ', period: ' .. tostring(show_day_period) .. ');')
end)

-- Enable/disable UI
-- WebUI:ExecuteJS('window.showUI();')
-- WebUI:ExecuteJS('window.hideUI());')
Events:Subscribe('UI:DrawHud', function()
	-- get player
	local player = PlayerManager:GetLocalPlayer()
	if player == nil or player.soldier == nil then
		if isKilled then
			WebUI:ExecuteJS('window.hideUI();')
			return
		end
	else
		isKilled = false
	end

	if (isHud and true) then
		WebUI:ExecuteJS('window.showUI();')
	else
		WebUI:ExecuteJS('window.hideUI();')
	end
end)
