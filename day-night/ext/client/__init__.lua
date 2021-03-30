local Settings = require('__shared/settings')
local Tools = require('__shared/tools')
local ClientTime = require('clienttime')
require('ui')
require('night_preset')


local client_day_night_cycle_seconds = 0

-- Level was loaded
Events:Subscribe('Level:Loaded', function()
	-- Initiate Client Time
    if Settings.day_night_cycle_enabled == true then 
        ClientTime:__Init()
    end
	-- Create Night preset
	Night()
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
