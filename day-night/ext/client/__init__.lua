require('__shared/ticks')
require('__shared/net')
require('__shared/tools')
require('ui')
require('night_preset')

local client_day_night_cycle_seconds = 0

-- Level was loaded
Events:Subscribe('Level:Loaded', function()
	-- Find Skybox Gradient Texture
	findSkyGradientTexture()
	-- Apply VE patches
	applyPatches()
	-- Create Night preset
	Night()
end)

-- Record Ticks
local engine_update_timer = 0.0
Events:Subscribe('Engine:Update', function(dt)
    
	if day_night_cycle_enabled == false then
		return
	end

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
	if show_UI_bar and day_night_cycle_enabled then
		WebUI:Init()
		WebUI:ExecuteJS('window.settings({days: ' .. tostring(show_days) .. ', period: ' .. tostring(show_day_period) .. ');')
	end
end)

-- Enable/disable UI
-- WebUI:ExecuteJS('window.showUI();')
-- WebUI:ExecuteJS('window.hideUI());')
Events:Subscribe('UI:DrawHud', function()
	-- Get player
	local s_player = PlayerManager:GetLocalPlayer()
	if s_player == nil or s_player.soldier == nil then
		if isKilled then
			WebUI:ExecuteJS('window.hideUI();')
			return
		end
	else
		isKilled = false
	end

	if isHud then
		WebUI:ExecuteJS('window.showUI();')
	else
		WebUI:ExecuteJS('window.hideUI();')
	end
end)

function findSkyGradientTexture()
	-- Find the sky gradient texture of the lowest priority (basic) VE
	local s_VEPriority = -1
	local s_VEStates = VisualEnvironmentManager:GetStates()
	
	for _, l_VEState in pairs(s_VEStates) do
		
		if l_VEState.sky ~= nil then
			
			if l_VEState.sky.skyGradientTexture ~= nil then

				if s_VEPriority < 0 or l_VEState.priority < s_VEPriority then
					s_VEPriority = l_VEState.priority

					m_SkyGradientTexture = l_VEState.sky.skyGradientTexture

					print('Sky gradient found: (VE priority: ' .. s_VEPriority .. ')')
					print(m_SkyGradientTexture)
				end
			end
		end
	end
end

-- Check Message
Hooks:Install('ClientChatManager:IncomingMessage', 1, function(p_hook, p_Message, p_PlayerId, p_RecipientMask, p_ChannelId, p_IsSenderDead)
	-- TODO: admins to set specific time
	--[[
	if p_Message == "!test" then
		findSkyGradientTexture()
	else
		print("No command detected")
	end
	]]
end)
