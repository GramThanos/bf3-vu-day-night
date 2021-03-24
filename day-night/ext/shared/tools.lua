require('__shared/ticks')

-- Calculate days & hours

-- Return day, hours as INT
function getDaysHours(seconds)
	
	-- Update hours & days
	local t_days = nil
    local t_hours = nil
	t_days, t_hours = getFloatDaysHours(seconds)
	t_hours = math.floor(t_hours)
	
	return t_days, t_hours
end

-- Return day, hours as float
function getFloatDaysHours(seconds)
	
	-- Update hours & days
	local t_days = math.floor(seconds / day_night_cycle_duration_in_seconds)
    local t_hours = seconds % day_night_cycle_duration_in_seconds / (day_night_cycle_duration_in_seconds / 24)
	
	return t_days, t_hours
end
