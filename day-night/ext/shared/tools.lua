local Settings = require('__shared/settings')
local Tools = class('Tools')

-- Calculate days & hours

-- Return day, hours as INT
function Tools:GetDaysHours(seconds)
	
	-- Update hours & days
	local t_days = nil
    local t_hours = nil
	t_days, t_hours = Tools:GetFloatDaysHours(seconds)
	t_hours = math.floor(t_hours)
	
	return t_days, t_hours
end

-- Return day, hours as float
function Tools:GetFloatDaysHours(seconds)
	
	-- Update hours & days
	local t_days = math.floor(seconds / Settings.day_night_cycle_duration_in_seconds)
    local t_hours = seconds % Settings.day_night_cycle_duration_in_seconds / (Settings.day_night_cycle_duration_in_seconds / 24)
	
	return t_days, t_hours
end

-- Enable/Disable all prints via Settings file
function Tools:DebugPrint(text, category)

    if Settings.debugPrints['enable'] == true then

		if Settings.debugPrints[category] == true then

        	print(tostring(text), 'Category: '.. category)

		else 

			--print('Not a valid category')
		
		end

	elseif Settings.debugPrints['enable'] == false then
        
		return

	else 

		print('Debug Print Configuration Error')

    end

end


return Tools
