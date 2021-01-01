require('__shared/ticks')
require('__shared/net')

-- DayNight profiles
local profiles = {}

-- Profile Night
profiles.night = {}
-- Profile Night > OutdoorLight
profiles.night.sunColor = Vec3(0.01, 0.01, 0.01)
profiles.night.skyColor = Vec3(0.01, 0.01, 0.01)
profiles.night.groundColor = Vec3(0, 0, 0)
profiles.night.skyEnvmapShadowScale = 0.5
-- Profile Night > Sky
profiles.night.brightnessScale = 0.01
profiles.night.sunSize = 0.01
profiles.night.sunScale = 1
profiles.night.cloudLayer1SunLightIntensity = 0.01
profiles.night.cloudLayer1SunLightPower = 0.01
profiles.night.cloudLayer1AmbientLightIntensity = 0.01
profiles.night.cloudLayer2SunLightIntensity = 0.01
profiles.night.cloudLayer2SunLightPower = 0.01
profiles.night.cloudLayer2AmbientLightIntensity = 0.01
profiles.night.staticEnvmapScale = 0.1
profiles.night.skyEnvmap8BitTexScale = 0.8
-- Profile Night > Fog
profiles.night.fogColor = Vec3(0.02, 0.02, 0.02)
-- Profile Night > Tonemap
profiles.night.minExposure = 2
profiles.night.maxExposure = 4
profiles.night.exposureAdjustTime = 0.5
profiles.night.middleGray = 0.02
-- Profile Night > Enlighten
profiles.night.skyBoxSkyColor = Vec3(0.01, 0.01, 0.01)
profiles.night.skyBoxBackLightColor = Vec3(0.01, 0.01, 0.01)
profiles.night.skyBoxGroundColor = Vec3(0.01, 0.01, 0.01)
profiles.night.terrainColor = Vec3(0.01, 0.01, 0.01)
profiles.night.skyBoxSunLightColor = Vec3(0.01, 0.01, 0.01)
profiles.night.bounceScale = 0.01
profiles.night.cullDistance = 0.01
profiles.night.esunScale = 0.01
profiles.night.skyBoxSunLightColorSize = 0.01
profiles.night.skyBoxBackLightColorSize = 0.01

profiles.night.mp_subway = {}
profiles.night.mp_subway.staticEnvmapScale = 0.01
profiles.night.mp_subway_subway = {}
profiles.night.mp_subway_subway.staticEnvmapScale = 0.1

-- Profile Day (will be initialized by the map's defaults)
profiles.day = {}
-- Profile Day > OutdoorLight
profiles.day.sunColor = nil
profiles.day.skyColor = nil
profiles.day.groundColor = nil
profiles.day.skyEnvmapShadowScale = nil
-- Profile Day > Sky
profiles.day.brightnessScale = nil
profiles.day.sunSize = nil
profiles.day.sunScale = nil
profiles.day.cloudLayer1SunLightIntensity = nil
profiles.day.cloudLayer1SunLightPower = nil
profiles.day.cloudLayer1AmbientLightIntensity = nil
profiles.day.cloudLayer2SunLightIntensity = nil
profiles.day.cloudLayer2SunLightPower = nil
profiles.day.cloudLayer2AmbientLightIntensity = nil
profiles.day.staticEnvmapScale = nil
profiles.day.skyEnvmap8BitTexScale = nil
-- Profile Day > Fog
profiles.day.fogColor = nil
-- Profile Night > Tonemap
profiles.day.minExposure = nil
profiles.day.maxExposure = nil
profiles.day.exposureAdjustTime = nil
profiles.day.middleGray = nil
-- Profile Night > Enlighten
profiles.day.skyBoxSkyColor = nil
profiles.day.skyBoxBackLightColor = nil
profiles.day.skyBoxGroundColor = nil
profiles.day.terrainColor = nil
profiles.day.skyBoxSunLightColor = nil
profiles.day.bounceScale = nil
profiles.day.cullDistance = nil
profiles.day.esunScale = nil
profiles.day.skyBoxSunLightColorSize = nil
profiles.day.skyBoxBackLightColorSize = nil

local cache_states = {}

-- Update
local function fVal(a, b, f)
    return a + ((b - a) * f)
end

local function vfVal(a, b, f)
    return Vec3(fVal(a.x, b.x, f), fVal(a.y, b.y, f), fVal(a.z, b.z, f))
end
local function updateDayNight()
    local factor = math.abs(hours % 24 - 12)/12

    local states = VisualEnvironmentManager:GetStates()
    for _, state in pairs(states) do
        if not cache_states[_] then
            cache_states[_] = {}
        end
        if state.outdoorLight ~= nil then
            if not cache_states[_].outdoorLight then
                cache_states[_].outdoorLight = {}
                cache_states[_].outdoorLight.sunColor = state.outdoorLight.sunColor
                cache_states[_].outdoorLight.skyColor = state.outdoorLight.skyColor
                cache_states[_].outdoorLight.groundColor = state.outdoorLight.groundColor
                cache_states[_].outdoorLight.skyEnvmapShadowScale = state.outdoorLight.skyEnvmapShadowScale
            end
            state.outdoorLight.sunColor = vfVal(cache_states[_].outdoorLight.sunColor, profiles.night.sunColor, factor)
            state.outdoorLight.skyColor = vfVal(cache_states[_].outdoorLight.skyColor, profiles.night.skyColor, factor)
            state.outdoorLight.groundColor = vfVal(cache_states[_].outdoorLight.groundColor, profiles.night.groundColor, factor)
            state.outdoorLight.skyEnvmapShadowScale = fVal(cache_states[_].outdoorLight.skyEnvmapShadowScale, profiles.night.skyEnvmapShadowScale, factor)

            --state.outdoorLight.sunRotationY = state.outdoorLight.sunRotationY + 10
            --state.outdoorLight.sunRotationX = state.outdoorLight.sunRotationX + 10
        end
        if state.sky ~= nil then
            if not cache_states[_].sky then
                cache_states[_].sky = {}
                cache_states[_].sky.brightnessScale = state.sky.brightnessScale
                cache_states[_].sky.sunSize = state.sky.sunSize
                cache_states[_].sky.sunScale = state.sky.sunScale
                cache_states[_].sky.cloudLayer1SunLightIntensity = state.sky.cloudLayer1SunLightIntensity
                cache_states[_].sky.cloudLayer1SunLightPower = state.sky.cloudLayer1SunLightPower
                cache_states[_].sky.cloudLayer1AmbientLightIntensity = state.sky.cloudLayer1AmbientLightIntensity
                cache_states[_].sky.cloudLayer2SunLightIntensity = state.sky.cloudLayer2SunLightIntensity
                cache_states[_].sky.cloudLayer2SunLightPower = state.sky.cloudLayer2SunLightPower
                cache_states[_].sky.cloudLayer2AmbientLightIntensity = state.sky.cloudLayer2AmbientLightIntensity
                cache_states[_].sky.staticEnvmapScale = state.sky.staticEnvmapScale
                cache_states[_].sky.skyEnvmap8BitTexScale = state.sky.skyEnvmap8BitTexScale
            end
            state.sky.brightnessScale = fVal(cache_states[_].sky.brightnessScale, profiles.night.brightnessScale, factor)
            state.sky.sunSize = fVal(cache_states[_].sky.sunSize, profiles.night.sunSize, factor)
            state.sky.sunScale = fVal(cache_states[_].sky.sunScale, profiles.night.sunScale, factor)
            state.sky.cloudLayer1SunLightIntensity = fVal(cache_states[_].sky.cloudLayer1SunLightIntensity, profiles.night.cloudLayer1SunLightIntensity, factor)
            state.sky.cloudLayer1SunLightPower = fVal(cache_states[_].sky.cloudLayer1SunLightPower, profiles.night.cloudLayer1SunLightPower, factor)
            state.sky.cloudLayer1AmbientLightIntensity = fVal(cache_states[_].sky.cloudLayer1AmbientLightIntensity, profiles.night.cloudLayer1AmbientLightIntensity, factor)
            state.sky.cloudLayer2SunLightIntensity = fVal(cache_states[_].sky.cloudLayer2SunLightIntensity, profiles.night.cloudLayer2SunLightIntensity, factor)
            state.sky.cloudLayer2SunLightPower = fVal(cache_states[_].sky.cloudLayer2SunLightPower, profiles.night.cloudLayer2SunLightPower, factor)
            state.sky.cloudLayer2AmbientLightIntensity = fVal(cache_states[_].sky.cloudLayer2AmbientLightIntensity, profiles.night.cloudLayer2AmbientLightIntensity, factor)
            state.sky.staticEnvmapScale = fVal(cache_states[_].sky.staticEnvmapScale, profiles.night.staticEnvmapScale, factor)
            state.sky.skyEnvmap8BitTexScale = fVal(cache_states[_].sky.skyEnvmap8BitTexScale, profiles.night.skyEnvmap8BitTexScale, factor)
        end
        if state.fog ~= nil then
            if not cache_states[_].fog then
                cache_states[_].fog = {}
                cache_states[_].fog.fogColor = state.fog.fogColor
            end
            state.fog.fogColor = vfVal(cache_states[_].fog.fogColor, profiles.night.fogColor, factor)
        end
        if state.tonemap ~= nil then
            if not cache_states[_].tonemap then
                cache_states[_].tonemap = {}
                cache_states[_].tonemap.minExposure = state.tonemap.minExposure
                cache_states[_].tonemap.maxExposure = state.tonemap.maxExposure
                cache_states[_].tonemap.exposureAdjustTime = state.tonemap.exposureAdjustTime
                cache_states[_].tonemap.middleGray = state.tonemap.middleGray
            end
            state.tonemap.minExposure = fVal(cache_states[_].tonemap.minExposure, profiles.night.minExposure, factor)
            state.tonemap.maxExposure = fVal(cache_states[_].tonemap.maxExposure, profiles.night.maxExposure, factor)
            state.tonemap.exposureAdjustTime = fVal(cache_states[_].tonemap.exposureAdjustTime, profiles.night.exposureAdjustTime, factor)
            state.tonemap.middleGray = fVal(cache_states[_].tonemap.middleGray, profiles.night.middleGray, factor)
        end
        if state.enlighten ~= nil then
            if not cache_states[_].enlighten then
                cache_states[_].enlighten = {}
                cache_states[_].enlighten.skyBoxSkyColor = state.enlighten.skyBoxSkyColor
                cache_states[_].enlighten.skyBoxBackLightColor = state.enlighten.skyBoxBackLightColor
                cache_states[_].enlighten.skyBoxGroundColor = state.enlighten.skyBoxGroundColor
                cache_states[_].enlighten.terrainColor = state.enlighten.terrainColor

                --cache_states[_].enlighten.sunScale = state.enlighten.sunScale
                --cache_states[_].enlighten.skyBoxSunLightColorSize = state.enlighten.skyBoxSunLightColorSize
                --cache_states[_].enlighten.skyBoxBackLightColorSize = state.enlighten.skyBoxBackLightColorSize
            end
            state.enlighten.skyBoxSkyColor = vfVal(profiles.day.skyBoxSkyColor, profiles.night.skyBoxSkyColor, factor)
            state.enlighten.skyBoxBackLightColor = vfVal(profiles.day.skyBoxBackLightColor, profiles.night.skyBoxBackLightColor, factor)
            state.enlighten.skyBoxGroundColor = vfVal(profiles.day.skyBoxGroundColor, profiles.night.skyBoxGroundColor, factor)
            state.enlighten.terrainColor = vfVal(profiles.day.terrainColor, profiles.night.terrainColor, factor)
            state.enlighten.skyBoxSunLightColor = vfVal(profiles.day.skyBoxSunLightColor, profiles.night.skyBoxSunLightColor, factor)
            --state.enlighten.bounceScale = fVal(profiles.day.bounceScale, profiles.night.bounceScale, factor)
            --state.enlighten.cullDistance = fVal(profiles.day.cullDistance, profiles.night.cullDistance, factor)
            --state.enlighten.sunScale = fVal(profiles.day.esunScale, profiles.night.esunScale, factor)
            --state.enlighten.skyBoxSunLightColorSize = fVal(profiles.day.skyBoxSunLightColorSize, profiles.night.skyBoxSunLightColorSize, factor)
            --state.enlighten.skyBoxBackLightColorSize = fVal(profiles.day.skyBoxBackLightColorSize, profiles.night.skyBoxBackLightColorSize, factor)
        end

        -- Sun flare should be enabled on day only
        --if state.sunFlare ~= nil then
        --    if factor < 0.5 then
        --        state.sunFlare.enable = true
        --    else
        --        state.sunFlare.enable = false
        --    end
        --end
    end


end

-- Initialize default values
Events:Subscribe('Partition:Loaded', function(partition)
    for _, instance in pairs(partition.instances) do
        -- Init OutdoorLight values
        if instance:Is('OutdoorLightComponentData') then
            --print('OutdoorLightComponentData')
            local outdoor = OutdoorLightComponentData(instance)
            outdoor:MakeWritable()

            profiles.day.sunColor = outdoor.sunColor:Clone()
            profiles.day.skyColor = outdoor.skyColor:Clone()
            profiles.day.groundColor = outdoor.groundColor:Clone()
            profiles.day.skyEnvmapShadowScale = outdoor.skyEnvmapShadowScale
        end
        -- Init Sky values
        if instance:Is('SkyComponentData') then
            --print('SkyComponentData')
            sky = SkyComponentData(instance)
            sky:MakeWritable()

            profiles.day.brightnessScale = sky.brightnessScale
            profiles.day.sunSize = sky.sunSize
            profiles.day.sunScale = sky.sunScale
            profiles.day.cloudLayer1SunLightIntensity = sky.cloudLayer1SunLightIntensity
            profiles.day.cloudLayer1SunLightPower = sky.cloudLayer1SunLightPower
            profiles.day.cloudLayer1AmbientLightIntensity = sky.cloudLayer1AmbientLightIntensity
            profiles.day.cloudLayer2SunLightIntensity = sky.cloudLayer2SunLightIntensity
            profiles.day.cloudLayer2SunLightPower = sky.cloudLayer2SunLightPower
            profiles.day.cloudLayer2AmbientLightIntensity = sky.cloudLayer2AmbientLightIntensity
            profiles.day.staticEnvmapScale = sky.staticEnvmapScale
            profiles.day.skyEnvmap8BitTexScale = sky.skyEnvmap8BitTexScale

            if sky.partition.name:match('mp_subway') or sky.partition.name:match('mp_011') then
                profiles.night.staticEnvmapScale = 0.01
            end

            if sky.partition.name:match('mp_subway_subway') then
                profiles.night.staticEnvmapScale = 0.1

                ResourceManager:RegisterInstanceLoadHandlerOnce(Guid('36536A99-7BE3-11E0-8611-A913E18AE9A4'), Guid('64EE680C-405E-2E81-E327-6DF58605AB0B'), function(loadedInstance)
                    sky.staticEnvmapTexture = TextureAsset(loadedInstance)
                end)
            end
        end
        -- Init Fog values
        if instance:Is('FogComponentData') then
            --print('FogComponentData')
            local fog = FogComponentData(instance)
            fog:MakeWritable()

            profiles.day.fogColor = fog.fogColor:Clone()
        end
        -- Init Tonemap values
        if instance:Is('TonemapComponentData') then
            --print('TonemapComponentData')
            local tonemap = TonemapComponentData(instance)
            tonemap:MakeWritable()

            profiles.day.minExposure = tonemap.minExposure
            profiles.day.maxExposure = tonemap.maxExposure
            profiles.day.exposureAdjustTime = tonemap.exposureAdjustTime
            profiles.day.middleGray = tonemap.middleGray
            --tonemap.tonemapMethod = TonemapMethod.TonemapMethod_FilmicNeutral
        end
        ---- Init ColorCorrection values
        --if instance:Is('ColorCorrectionComponentData') then
        --    local color = ColorCorrectionComponentData(instance)
        --    color:MakeWritable()
        --
        --    if instance.partition.name:match('menuvisualenvironment') then
        --        color.brightness = Vec3(1, 1, 1)
        --        color.contrast = Vec3(1, 1, 1)
        --        color.saturation = Vec3(0.5, 0.5, 0.5)
        --    end
        --    
        --    if instance.partition.name:match('outofcombat') then
        --        color.contrast = Vec3(0.9, 0.9, 0.9)
        --    end
        --end
        -- Init Enlighten values
        if instance:Is('EnlightenComponentData') then
            --print('EnlightenComponentData')
            local enlighten = EnlightenComponentData(instance)
            enlighten:MakeWritable()

            profiles.day.skyBoxSkyColor = enlighten.skyBoxSkyColor:Clone()
            profiles.day.skyBoxBackLightColor = enlighten.skyBoxBackLightColor:Clone()
            profiles.day.skyBoxGroundColor = enlighten.skyBoxGroundColor:Clone()
            profiles.day.terrainColor = enlighten.terrainColor:Clone()
            profiles.day.skyBoxSunLightColor = enlighten.skyBoxSunLightColor:Clone()
            profiles.day.bounceScale = enlighten.bounceScale
            profiles.day.cullDistance = enlighten.cullDistance
            profiles.day.esunScale = enlighten.sunScale
            profiles.day.skyBoxSunLightColorSize = enlighten.skyBoxSunLightColorSize
            profiles.day.skyBoxBackLightColorSize = enlighten.skyBoxBackLightColorSize
            
            --enlighten.enable = false
        end
        -- Init SunFlare values
        if instance:Is('SunFlareComponentData') then
            local flare = SunFlareComponentData(instance)
            flare:MakeWritable()
            flare.excluded = true
        end
        -- Init Mesh values
        --if instance:Is('MeshAsset') then
        --    if
        --        instance.partition.name:match('mp_011/objects/mp011_backdrop') or
        --        instance.partition.name:match('mp_012/terrain/mp012_matte') or
        --        instance.partition.name:match('mp_012/objects/smokestacks') or
        --        instance.partition.name:match('mp_018/terrain/mp018_matte')
        --    then
        --        local mesh = MeshAsset(instance)
        --        mesh:MakeWritable()
        --
        --        for _, value in pairs(mesh.materials) do
        --            value:MakeWritable()
        --            value.shader.shader = nil
        --        end
        --    end
        --end
        --
        --if instance:Is('MeshMaterialVariation') then
        --    if instance.partition.name:match('mp_012/objects/smokestacks') then
        --        local variation = MeshMaterialVariation(instance)
        --        variation:MakeWritable()
        --        variation.shader.shader = nil
        --    end
        --end
    end


end)

-- Record Ticks
local engine_update_timer = 0.0
Events:Subscribe('Engine:Update', function(dt)
    engine_update_timer = engine_update_timer + dt
    if engine_update_timer < client_update_environment then
        return
    end
    local second_passed = engine_update_timer
    engine_update_timer = 0.0

    -- Update hours & days
    hours = hours + (daytime_hour_change_per_second * second_passed)
    if hours >= 24 then
        days = days + 1
        hours = hours % 24
    end

    -- Update environment lighting
    updateDayNight()
    -- Update UI indicators
    WebUI:ExecuteJS('window.update(' .. tostring(days) .. ', ' .. tostring(hours) .. ');')

    -- Print Debug info
    if print_ticks_daytime_info == true then
        local factor = math.abs(hours % 24 - 12)/12
        print('Datetime : ' .. tostring(days) .. ' days ' .. tostring(hours) .. ' hours' .. ' -> ' .. tostring(factor))
    end
end)

-- Listen to sync from server
NetEvents:Subscribe(NetMessage.S2C_SYNC_DAYTIME, function(serverHours)
    -- Update hours and days from server
    days = (serverHours - (serverHours % 24)) / 24
    hours = serverHours % 24

    -- Print Debug info
    if print_ticks_daytime_info == true then
        local factor = math.abs(hours % 24 - 12)/12
        print('Server Datetime Sync : ' .. tostring(days) .. ' days ' .. tostring(hours) .. ' hours' .. ' -> ' .. tostring(factor))
    end
end)

-- Load UI
Events:Subscribe('Extension:Loaded', function()
    WebUI:Init()
    WebUI:ExecuteJS('window.settings({days: ' .. tostring(show_days) .. ', period: ' .. tostring(show_day_period) .. ');')
end)

Events:Subscribe('Player:Respawn', function(player)
    WebUI:ExecuteJS('window.showUI();')
end)

Events:Subscribe('Player:Killed', function(player)
    WebUI:ExecuteJS('window.hideUI());')
end)
