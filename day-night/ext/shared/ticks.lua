
---- YOU MAY EDIT THE PARAMETERS BELOW ----

-- How many minutes should a day last
-- Example Values:
-- 		full day night circle in 20 minutes 					: 20
-- 		full day night circle in 10 minutes (suggested value) 	: 15
-- 		full day night circle in 10 minutes 					: 10
-- 		1 hour per second (good for developers) 				: 24/60
day_duration_in_minutes = 15

-- How often, in seconds, should client update the environment (applying the new time lighting)
-- This value can be increased if the day night circle is big enough
client_update_environment = 1

-- How often, in seconds, should the server update daytime and send info to the clients
-- The server sends at this interval the new date time to the clients to keep them all in sync
server_update_daytime = 10

-- The day time to start the server at (0 - 23)
start_hour = 12
randomize_start_hour = false
reset_days_hours_for_each_level = true

-- Show days on indicator
show_days = true
show_day_period = true





---- DONT CHANGE ANYTHING AFTER THIS LINE ----

-- Generated settings based at the parameters above
daytime_hour_change_per_second = (24 * 1) / (day_duration_in_minutes * 60)
daytime_hour_change_per_tick = (24 * client_update_environment) / (day_duration_in_minutes * 60)

-- Sever day & hour state
days = 1
hours = start_hour

-- Debug (turn this on to print the time at the console)
print_ticks_daytime_info = false
