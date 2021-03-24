
---- YOU MAY EDIT THE PARAMETERS BELOW ----

-- How many minutes should a day last
-- Example Values:
-- 		full day night circle in 20 minutes 					: 20
-- 		full day night circle in 15 minutes (suggested value) 	: 15
-- 		full day night circle in 10 minutes 					: 10
-- 		1 hour per second (good for debugging) 					: 24/60
day_night_cycle_duration_in_minutes = 1

-- Pure night duration in minutes
pure_night_duration = 0.1
-- Pure day duration in minutes
pure_day_duration = 0.1


-- How often, in seconds, should client update the environment (applying the new time lighting)
-- This value can be increased if the day night circle is big enough
client_update_environment = 0.001

-- How often, in seconds, should the server update daytime and send info to the clients
-- The server sends at this interval the new date time to the clients to keep them all in sync
server_update_daytime = 30

-- The day time to start the server at (0 - 23)
start_hour = 12
randomize_start_hour = false
reset_days_hours_for_each_level = true

-- Show days on indicator
show_days = true
show_day_period = true





---- DONT CHANGE ANYTHING AFTER THIS LINE ----

-- Generated settings based at the parameters above
day_night_cycle_duration_in_seconds = day_night_cycle_duration_in_minutes * 60
pure_night_duration_sec = pure_night_duration * 60
pure_day_duration_sec = pure_day_duration * 60

-- Sever day & hour state
days = 0
hours = start_hour % 24

-- Debug (turn this on to print the time at the console)
print_ticks_daytime_info = true
