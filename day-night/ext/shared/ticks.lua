
-- Parameters
--day_duration_in_minutes = 10 -- How many minutes should a day last
day_duration_in_minutes = 24/60 -- How many minutes should a day last
client_update_environment = 1 -- How often, in seconds, should client update the environment to the new daytime
server_update_daytime = 10 -- How often, in seconds, should the server update daytime and send info to the clients
start_hour = 12 -- The daytime to start round


---- DONT CHANGE ANYTHING AFTER THIS LINE ----


-- Generated Parameters
daytime_hour_change_per_second = (24 * 1) / (day_duration_in_minutes*60)
daytime_hour_change_per_tick = (24 * client_update_environment) / (day_duration_in_minutes*60)

-- State
days = 0
hours = start_hour

-- Debug
print_ticks_daytime_info = true
