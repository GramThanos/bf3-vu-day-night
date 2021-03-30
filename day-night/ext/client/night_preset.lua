local nightPreset = nil
local Tools = require('__shared/tools')
local Settings = require('__shared/settings')

-- Based on Code by Orfeas Zafeiris
-- expanded by IllustrisJack

function Night()
	
	local nightData = VisualEnvironmentEntityData()
	nightData.enabled = true
	nightData.visibility = Settings.night_darkness
	nightData.priority = 999999

	local outdoorLight = OutdoorLightComponentData()
	outdoorLight.enable = true
	outdoorLight.realm = 0

	outdoorLight.skyColor = Vec3(0.01, 0.01, 0.01)
	outdoorLight.groundColor = Vec3(0, 0, 0)
	outdoorLight.sunColor = Vec3(0.01, 0.01, 0.01)

	outdoorLight.cloudShadowEnable = true
	outdoorLight.cloudShadowSize = 2000.0
	outdoorLight.cloudShadowExponent = 3
	outdoorLight.cloudShadowCoverage = 0.44
	outdoorLight.cloudShadowSpeed = Vec2(-15.000000, -15.000000)

	outdoorLight.skyLightAngleFactor = 0.009
	outdoorLight.sunSpecularScale = 0.25
	outdoorLight.skyEnvmapShadowScale = 0.5
	outdoorLight.sunShadowHeightScale = 0.3

	outdoorLight.translucencyDistortion = 0.10
	outdoorLight.translucencyAmbient = 0
	outdoorLight.translucencyScale = 1
	outdoorLight.translucencyPower = 80.0

	outdoorLight.sunRotationX = 255
	outdoorLight.sunRotationY = 25

	local sky = SkyComponentData()
	sky.brightnessScale = 0.01
	sky.enable = true
	if hide_sun then
		sky.sunSize = 0.0
		sky.sunScale = 0.0
	else
		sky.sunSize = 0.013
		sky.sunScale = 0.6
	end
	sky.panoramicTexture = nil -- TextureAsset(_G.MoonNightSkybox)
	sky.panoramicAlphaTexture = nil -- extureAsset(_G.MoonNightAlpha)
	sky.staticEnvmapTexture = nil -- TextureAsset(_G.MoonNightEnvmap)

	if m_SkyGradientTexture ~= nil then
		sky.skyGradientTexture = TextureAsset(m_SkyGradientTexture) --TextureAsset(_G.MoonNightGradient)
		Tools:DebugPrint("Sky Gradient Texture applied", 'VE')
	end
	sky.realm = 2
	sky.panoramicUVMinX = 0.281
	sky.panoramicUVMaxX = 0.299
	sky.panoramicUVMinY = 0.063
	sky.panoramicUVMaxY = 0.307
	sky.panoramicTileFactor = 1.0
	sky.panoramicRotation = 260
	sky.staticEnvmapScale = 0
	sky.skyVisibilityExponent = 0.2
	sky.skyEnvmap8BitTexScale = 1
	sky.customEnvmapScale = 1
	sky.customEnvmapAmbient = 1
	--sky.cloudLayer1Texture = nil -- TextureAsset(_G.MoonNightStars)
	--sky.cloudLayer1Altitude = 2000000.0
	--sky.cloudLayer1TileFactor = 0.600000023842
	--sky.cloudLayer1Rotation = 237.072998047
	--sky.cloudLayer1Speed = -0.0010000000475
	--sky.cloudLayer1SunLightIntensity = 0.3
	--sky.cloudLayer1SunLightPower = 0.3
	--sky.cloudLayer1AmbientLightIntensity = 0.5
	--sky.cloudLayer1AlphaMul = 0.25

	local colorCorrection = ColorCorrectionComponentData()
	colorCorrection.enable = true
	colorCorrection.brightness = Vec3(1, 1, 1)
	colorCorrection.contrast = Vec3(1.1, 1.1, 1.1)
	colorCorrection.saturation = Vec3(1, 1, 1.05)

	local tonemap = TonemapComponentData()
	tonemap.tonemapMethod = 2
	tonemap.minExposure = 0.25
	tonemap.maxExposure = 1.75
	tonemap.exposureAdjustTime = 1.75
	tonemap.bloomScale = Vec3(0.2, 0.2, 0.2)

	local fog = FogComponentData()
	fog.enable = true
	fog.realm = 0
	fog.start = 25
	fog.endValue = 800
	fog.curve = Vec4(0.4, -0.77, 1.3, -0.01)
	fog.fogDistanceMultiplier = 1.0
	fog.fogGradientEnable = true
	fog.fogColorEnable = true
	--[[ -- bright Night
	fog.fogColor = Vec3(0.08, 0.0615, 0.0157)
	fog.fogColorCurve = Vec4(6.1, -11.7, 5.62, -0.18)
	fog.fogColorStart = 0
	fog.fogColorEnd = 5000
	]]--
	fog.fogColor = Vec3(0.0001, 0.0001, 0.0001)
	fog.fogColorCurve = Vec4(0.4, 0.35, 0.2, -2)
	fog.fogColorStart = 2
	fog.fogColorEnd = 30

	fog.transparencyFadeStart = 0
	fog.transparencyFadeClamp = 1
	--fog.transparencyFadeEnd = 150 -- bright Night
	fog.transparencyFadeEnd = 50

	fog.heightFogEnable = false

	local enlighten = EnlightenComponentData()
	enlighten.enable = false
	enlighten.bounceScale = 1
	enlighten.sunScale = 0.00002
	enlighten.skyBoxEnable = false

	local sunFlare = SunFlareComponentData()
	sunFlare.enable = false

	local character = CharacterLightingComponentData()
	character.characterLightEnable = true
	character.topLight = Vec3(0.1, 0.1, 0.1)
	character.bottomLight = Vec3(0.1, 0.1, 0.1)
	

	nightData.components:add(outdoorLight)
	nightData.runtimeComponentCount = nightData.runtimeComponentCount + 1

	nightData.components:add(colorCorrection)
	nightData.runtimeComponentCount = nightData.runtimeComponentCount + 1

	nightData.components:add(tonemap)
	nightData.runtimeComponentCount = nightData.runtimeComponentCount + 1

	nightData.components:add(fog)
	nightData.runtimeComponentCount = nightData.runtimeComponentCount + 1

	nightData.components:add(sky)
	nightData.runtimeComponentCount = nightData.runtimeComponentCount + 1

	nightData.components:add(enlighten)
	nightData.runtimeComponentCount = nightData.runtimeComponentCount + 1

	nightData.components:add(sunFlare)
	nightData.runtimeComponentCount = nightData.runtimeComponentCount + 1

	nightData.components:add(character)
	nightData.runtimeComponentCount = nightData.runtimeComponentCount + 1

	nightPreset = EntityManager:CreateEntity(nightData, LinearTransform())

	if nightPreset ~= nil then
		nightPreset:Init(Realm.Realm_Client, true)
		Tools:DebugPrint('Night VE preset added', 'VE')
	end
	
end

function removebNight()

	if nightPreset ~= nil then
		nightPreset:Destroy()
		nightPreset = nil

		Tools:DebugPrint('Night VE preset removed', 'VE')
	end

	if m_SkyGradientTexture ~= nil then
		m_SkyGradientTexture = nil
	end
end

-- Remove the VE state when the mod is unloading.
Events:Subscribe('Extension:Unloading', function()
	removebNight()
end)