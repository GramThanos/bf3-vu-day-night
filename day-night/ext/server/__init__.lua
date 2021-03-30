local Settings = require('__shared/settings')
local Tools = require('__shared/tools')
local NetMessage = require('__shared/net')
require('updateCheck')

local Time = class('Time')

Events:Subscribe('Level:Loaded', function(levelName, gameMode, round, roundsPerMap)

    Time:__Init()
    levelLoaded = true 

    -- Broadcast to sync already joined players
    Time:Broadcast()

end)

function Time:__Init()


    self.serverDayLength = 0.0 
    self.engineUpdateTimer = 0.0
    Time:Ticks()
    Time:PlayerJoin()

    
    if Settings.reset_days_hours_for_each_level == true then 

        days = 0 
        hours = Settings.start_hour % 24 

        if Settings.randomize_start_hour == true then 
            hours = math.random(0, 23)
        end
        
        self.serverDayLength = hours / 24 * self.serverDayLength

    end 


end

function Time:Ticks()

    if Settings.use_ticket_based_cycle ~= true then 

        -- Record Ticks
        Events:Subscribe('Engine:Update', function(dt)

            self.engineUpdateTimer = self.engineUpdateTimer + dt
            self.serverDayLength = self.serverDayLength + dt
            
            -- Print Debug info
            if Settings.DebugPrints['enable'] == true then

                if Settings.DebugPrints['time'] == true then

                -- Update hours & days-- Update hours & days
                self.days = nil
                self.hours = nil
                self.days, self.hours = Tool:getDaysHours(self.serverDayLength)
                    
                    if hours ~= self.hours or days ~= self.days then
                        days = self.days
                        hours = self.hours
                        Tool:DebugPrint('Current Time | Day: ' ..tostring(days) .. 'Hour: '.. tostring(hours), 'time')
                    end

                end

            end
            
            -- Check if it is time to send a client update (to ensure client sync)
            if self.engineUpdateTimer < Settings.serverUpdatesFrequency then
                return
            end
            self.engineUpdateTimer = 0.0
            
            -- Sync players
            Time:Broadcast()
            
        end)

    end

end 

function Time:Broadcast()

    Tools:DebugPrint("[Broadcast] Date: " .. tostring(self.serverDayLength) .. " sec", 'time')
    NetEvents:Broadcast(NetMessage.S2C_SYNC_DAYTIME, self.serverDayLength)
    ChatManager:SendMessage('Synchronizing Players')

end

function Time:PlayerJoin()

    Events:Subscribe('Player:Authenticated', function(name, playerGuid, ipAddress, accountGuid)

        Tools:DebugPrint("[Authenticated Broadcast] Date: " .. tostring(self.serverDayLength) .. " sec", 'time')
        NetEvents:Broadcast(NetMessage.S2C_SYNC_DAYTIME, self.serverDayLength)
    
    end)

end




return Time


