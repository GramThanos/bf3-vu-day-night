
---- YOU MAY EDIT THE PARAMETERS BELOW ----

-- GENERAL SETTINGS
local day_night_cycle_enabled = true
local use_ticket_based_cycle = false
local use_day_2_night = false -- instead of night 2 day in ticket mode
local hide_sun = false
local night_darkness = 0.99 -- 0 is day, 1 is pitch black (0.99 is the default)
local show_UI_bar = true -- show day-night cycle bar (day-night cycle needs to be enabled)

-- DAY-NIGHT CYCLE SETTINGS

-- How many minutes should a day last
-- Example Values:
-- 		full day night circle in 20 minutes 					: 20
-- 		full day night circle in 15 minutes (suggested value) 	: 15
-- 		full day night circle in 10 minutes 					: 10
-- 		1 hour per second (good for debugging) 					: 24/60
--══════════════════════════════════════════════════════════════════════════════════════════════════════--
-- FOLLOWING OPTIONS BECOME OBSOLETE IN TICKET MODE ⇊
local day_night_cycle_duration_in_minutes = 15

-- Pure night duration in minutes 
local pure_night_duration = 0.1
-- Pure day duration in minutes
local pure_day_duration = 0.1

-- How often, in seconds, should the server update daytime and send info to the clients
-- The server sends at this interval the new date time to the clients to keep them all in sync
local server_update_daytime = 30

-- The day time to start the server at (0 - 23)
local start_hour = 0	-- For real time use this value os.time('%H')
local randomize_start_hour = true
local reset_days_hours_for_each_level = true
--══════════════════════════════════════════════════════════════════════════════════════════════════════--


-- Show days on indicator
local show_days = true
local show_day_period = true


-- Debug Prints -- 
-- Used to display certain actions and to print them--
local debugPrints = {

    ['enable'] = true,  -- Enable Prints
    ['info'] = true,    -- Enable Console Time Prints [ON by default]
    ['time'] = false,   -- Enable Time Function related Prints
    ['VE'] = true,      -- Enable Visual Environment related Prints

}



--══════════════════════════════════════════════════════════════════════════════════════════════════════--
                            ---- DONT CHANGE ANYTHING AFTER THIS LINE ----

-- Generated settings based at the parameters above
local day_night_cycle_duration_in_seconds = day_night_cycle_duration_in_minutes * 60
local pure_night_duration_sec = pure_night_duration * 60
local pure_day_duration_sec = pure_day_duration * 60

-- Sever day & hour state
days = 0
hours = start_hour % 24

-- Debug (turn this on to print the time at the console)
local print_ticks_daytime_info = true





return {
    day_night_cycle_enabled = day_night_cycle_enabled,
    hide_sun = hide_sun,
    night_darkness = night_darkness,
    show_UI_bar = show_UI_bar,
    day_night_cycle_duration_in_minutes = day_night_cycle_duration_in_minutes,
    pure_night_duration = pure_night_duration,
    pure_day_duration = pure_day_duration,
    server_update_daytime = server_update_daytime,
    start_hour = start_hour,
    randomize_start_hour = randomize_start_hour,
    reset_days_hours_for_each_level = reset_days_hours_for_each_level,
    show_days = show_days,
    show_day_period = show_day_period,
    day_night_cycle_duration_in_seconds = day_night_cycle_duration_in_seconds,
    pure_night_duration_sec = pure_night_duration_sec,
    pure_day_duration_sec = pure_day_duration_sec,
    print_ticks_daytime_info = print_ticks_daytime_info,
    debugPrints = debugPrints,
    use_ticket_based_cycle = use_ticket_based_cycle,
    use_day_2_night = use_day_2_night,
}