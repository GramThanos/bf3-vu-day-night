local ClientTime = class('ClientTime')
local NetMessage = require('__shared/net')
local Settings = require('__shared/settings')
require('ui')

function ClientTime:__Init()

    self.factor = 1
    self.clientDayLength = 0
    self.previousNightFactor = nil
    self.t = 0
    -- Get Visual Environments
    ClientTime:GetVE()
    -- Find Skybox Gradient Texture
	ClientTime:FindSkyGradientTexture()
	-- Apply VE patches
	ClientTime:ApplyPatches()
    -- Activate Ticks
    ClientTime:Ticks()
    -- Activate Server Sync
    if Settings.use_ticket_based_cycle ~= true then 
        ClientTime:Sync()
    end 

end

function ClientTime:GetVE()

    VES = VisualEnvironmentManager:GetStates()

end

function ClientTime:Ticks()

    -- Record Ticks
    self.engineUpdateTimer = 0.0 

    Events:Subscribe('Engine:Update', function(dt)

        if Settings.use_ticket_based_cycle ~= true then 

            self.clientDayLength = self.clientDayLength + dt
            
            -- Offset seconds to 0:00 AM
            self.seconds = self.clientDayLength % Settings.day_night_cycle_duration_in_seconds

            --print(self.seconds)

            -- Offset seconds (0 is the middle of the night, but it should be the start of the night)
            --seconds = seconds + pure_night_duration_sec / 2
            
            self.factor = nil
            
            -- Check if it is night
            if self.seconds < Settings.pure_night_duration_sec / 2 then
                self.factor = 1.0

            -- Check if it is night -> day
            elseif self.seconds < Settings.day_night_cycle_duration_in_seconds / 2 - Settings.pure_day_duration_sec / 2 then
                self.factor = 1.0 - (self.seconds - Settings.pure_night_duration_sec / 2) / (Settings.day_night_cycle_duration_in_seconds / 2 - Settings.pure_day_duration_sec / 2 - Settings.pure_night_duration_sec / 2)
                
            -- Check if it is day
            elseif self.seconds < Settings.day_night_cycle_duration_in_seconds / 2 + Settings.pure_day_duration_sec / 2 then
                self.factor = 0.001
                
            -- Check if it is day -> night
            elseif self.seconds < Settings.day_night_cycle_duration_in_seconds - Settings.pure_night_duration_sec / 2 then
                self.factor = (self.seconds - Settings.day_night_cycle_duration_in_seconds / 2 - Settings.pure_day_duration_sec / 2) / (Settings.day_night_cycle_duration_in_seconds - Settings.pure_night_duration_sec / 2 - Settings.day_night_cycle_duration_in_seconds / 2 - Settings.pure_day_duration_sec / 2)

            -- Check if it is night
            else
                self.factor = 1.0
            end
            
            -- Update environment lighting
            ClientTime:UpdateVE()

            -- Update UI indicators
            local t_days = nil
            local t_hours = nil
            t_days, t_hours = Tools:GetFloatDaysHours(self.clientDayLength)
            
            WebUI:ExecuteJS('window.update(' .. tostring(t_days) .. ', ' .. tostring(t_hours) .. ');')
            t_hours = math.floor(t_hours)
                
            -- Update hours & days
            
            -- Print Debug info
            if self.hours ~= hours or self.days ~= days then 
                self.hours = hours 
                self.days = days

                Tools:DebugPrint('Datetime : ' .. tostring(days) .. ' days ' .. tostring(hours) .. ' hours' .. ' -> ' .. tostring(self.factor), 'time')

            end

        elseif Settings.use_ticket_based_cycle == true then 

            -- Get Team Tickets
            self.ticketsUS, self.ticketsRU = ClientTime:GetTicketCounterTickets()

            if self.ticketsUS == nil or self.ticketsRU == nil or type(self.ticketsUS) == 'string' or type(self.ticketsRU) == 'string' then
                return 
            end

            -- Get Total Tickets
            self.totaltickets = self.ticketsUS + self.ticketsRU 

            -- Set Maximum Tickets
            if self.maxtickets == nil and self.totaltickets ~= 0 then 
                self.maxtickets = self.totaltickets 
            end

            if self.maxtickets == nil then 
                return
            end

            self.clientDayLength = self.clientDayLength + dt

            if Settings.use_day_2_night == true then 
                self.factor = 1 - (self.totaltickets / self.maxtickets)
            else
                self.factor = self.totaltickets / self.maxtickets
            end 

            ClientTime:UpdateVE()

        end

    end)

end

-- Change visibility
function ClientTime:UpdateVE()
        
    if self.factor ~= self.previousNightFactor then

        if self.states == nil then
            self.states = VisualEnvironmentManager:GetStates()
        end
        VisualEnvironmentManager:SetDirty(true)
        
        -- Update preset visibility
        for _, state in pairs(self.states) do

            if state.priority == self.s_VEPriority then 

                state.outdoorLight.sunColor = Vec3(1,0.3,0.051)
                state.outdoorLight.sunRotationX = 90
                state.outdoorLight.sunRotationY = 25

                state.sky.sunSize = 0.01
                state.sky.sunScale = 3

            end
            -- Check if night preset
            if state.priority == 999999 then

                state.visibility = self.factor * Settings.night_darkness

                print('Changing Night VE')

            end

        end


        Tools:DebugPrint('Changing VE: ' .. self.factor, 'VE')
        
        self.previousNightFactor = self.factor
    end			
end

function ClientTime:Sync()

    -- Listen to sync from server
    NetEvents:Subscribe(NetMessage.S2C_SYNC_DAYTIME, function(serverTime)

        self.clientDayLength = serverTime
        
        -- Update hours and days from server
        days, hours = Tools:GetDaysHours(serverTime)

        -- Print Debug info
        Tools:DebugPrint('Server Datetime Sync : ' .. tostring(days) .. ' days ' .. tostring(hours) .. ' hours', 'time')

    end)

end


function ClientTime:GetTicketCounterTickets()
    -- Function Code credit BreeArnold
    local clientTicketCounterIterator = EntityManager:GetIterator('ClientTicketCounterEntity')
    local ticketCounterEntity = clientTicketCounterIterator:Next()
    local usTickets = " "
    local ruTickets = " "

    while ticketCounterEntity ~= nil do
        if TicketCounterEntity(ticketCounterEntity).team == TeamId.Team1 then
            usTickets = TicketCounterEntity(ticketCounterEntity).ticketCount
        else
            ruTickets = TicketCounterEntity(ticketCounterEntity).ticketCount
        end
        ticketCounterEntity = clientTicketCounterIterator:Next()
    end

    return usTickets, ruTickets

end

-- Hide Sun
function ClientTime:ApplyPatches()

    if VES == nil then
        VES = VisualEnvironmentManager:GetStates()
    end

	for _, state in pairs(VES) do
		
		if hide_sun then
			if state.sky ~= nil then
				state.sky.sunScale = 0
				state.sky.sunSize = 0
				print('Sun off')
			end
			
			if state.sunFlare ~= nil then
				state.sunFlare.enable = false
				print('Sunflares off')
			end
		end

		if day_night_cycle_enabled then
			if state.sky ~= nil then
				state.sky.panoramicUVMinX = 0.280999988317
				state.sky.panoramicUVMaxX = 0.298999994993
				state.sky.panoramicUVMinY = 0.0630000010133
				state.sky.panoramicUVMaxY = 0.307000011206
				state.sky.panoramicTileFactor = 1.0
				state.sky.panoramicRotation = 260
				print('Sky scale patch applied')
			end
		end

	end
end

function ClientTime:FindSkyGradientTexture()
	-- Find the sky gradient texture of the lowest priority (basic) VE
	self.s_VEPriority = -1
	
    if VES == nil then
        VES = VisualEnvironmentManager:GetStates()
    end
	
	for _, l_VEState in pairs(VES) do
		
		if l_VEState.sky ~= nil then
			
			if l_VEState.sky.skyGradientTexture ~= nil then

				if self.s_VEPriority < 0 or l_VEState.priority < self.s_VEPriority then
					self.s_VEPriority = l_VEState.priority

					m_SkyGradientTexture = l_VEState.sky.skyGradientTexture
                    m_panoramicXmin = l_VEState.sky.panoramicUVMinX
                    m_panoramicXmax = l_VEState.sky.panoramicUVMaxX 
                    m_panoramicYmin = l_VEState.sky.panoramicUVMinY
                    m_panoramicYmax = l_VEState.sky.panoramicUVMaxY
                    m_panoramicTileFactor = l_VEState.sky.panoramicTileFactor
                    m_panoramicRotation = l_VEState.sky.panoramicRotation

					print('Sky gradient found: (VE priority: ' .. self.s_VEPriority .. ')')
					print(m_SkyGradientTexture)
				end
			end
		end
	end
end

function ClientTime:OnLevelDestroyed()

    Events:Unsubscribe('Engine:Update')

end

return ClientTime