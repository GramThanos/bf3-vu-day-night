local nightPreset = nil
local shaderParams = nil
local outdoorLight = nil
local sky = nil
local fog = nil
local tonemap = nil
local cc = nil
local enlighten = nil
local sunFlare = nil

-- Based on Code by Orfeas Zafeiris
-- expanded by IllustrisJack

function Night()

	if nightPreset ~= nil then
		return
	end
	
	local nightData = VisualEnvironmentEntityData()
	nightData.enabled = true
	nightData.visibility = 1.0
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

	outdoorLight.skyLightAngleFactor = 0.0089999996125698
	outdoorLight.sunSpecularScale = 0.25
	outdoorLight.skyEnvmapShadowScale = 0.5
	outdoorLight.sunShadowHeightScale = 0.3

	outdoorLight.translucencyDistortion = 0.10000000149012
	outdoorLight.translucencyAmbient = 0
	outdoorLight.translucencyScale = 1
	outdoorLight.translucencyPower = 80.0

	outdoorLight.sunRotationX = 255.48399353027
	outdoorLight.sunRotationY = 25

	local sky = SkyComponentData()
	sky.brightnessScale = 0.3
	sky.enable = true
	sky.sunSize = 0.013
	sky.sunScale = 0.6
	sky.panoramicTexture = TextureAsset(_G.MoonNightSkybox)
	sky.panoramicAlphaTexture = TextureAsset(_G.MoonNightAlpha)
	sky.staticEnvmapTexture = TextureAsset(_G.MoonNightEnvmap)
	sky.skyGradientTexture = TextureAsset(_G.MoonNightGradient)
	sky.realm = 2
	sky.panoramicUVMinX = 0.280999988317
	sky.panoramicUVMaxX = 0.298999994993
	sky.panoramicUVMinY = 0.0630000010133
	sky.panoramicUVMaxY = 0.307000011206
	sky.panoramicTileFactor = 1.0
	sky.panoramicRotation = 260
	sky.staticEnvmapScale = 1
	sky.skyVisibilityExponent = 0.2
	sky.skyEnvmap8BitTexScale = 1
	sky.customEnvmapScale = 1
	sky.customEnvmapAmbient = 1
	sky.cloudLayer1Texture = TextureAsset(_G.MoonNightStars)
	sky.cloudLayer1Altitude = 2000000.0
	sky.cloudLayer1TileFactor = 0.600000023842
	sky.cloudLayer1Rotation = 237.072998047
	sky.cloudLayer1Speed = -0.0010000000475
	sky.cloudLayer1SunLightIntensity = 0.3
	sky.cloudLayer1SunLightPower = 0.3
	sky.cloudLayer1AmbientLightIntensity = 0.5
	sky.cloudLayer1AlphaMul = 0.25

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
	sunFlare.enable = true

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
	end
	
end

function removebNight()
	if nightPreset ~= nil then
		nightPreset:Destroy()
		nightPreset = nil
		print('removed VES Bright_Night')
		return true
	end
end

-- Change visibility
local previous_night_factor = nil
function update_night_visibility(factor)
    -- local factor = math.abs(hours % 24 - 12)/12
	
	if nightPreset == nil then
		return
	end
	
	--local night_factor = math.max(0, 1 - (1-factor+0.3)^8)
	local night_factor = factor
	
	if (night_factor ~= previous_night_factor) then
		--print( factor .. " -> N" .. night_factor)
		--[[
		print("*visibility is: " .. nightPreset.visibility)
		nightPreset.visibility = night_factor
		VisualEnvironmentManager:SetDirty(true)
		]]--
		
		local states = VisualEnvironmentManager:GetStates()
		-- Update preset visibility
		for _, state in pairs(states) do
			-- Check if night preset
			if state.priority == 999999 then
				--print("*visibility is: " .. state.visibility)
				state.visibility = night_factor
				VisualEnvironmentManager:SetDirty(true)
				--print("*visibility changed: " .. state.visibility)
			end
		end
		
		previous_night_factor = night_factor
	end			
end

-- Remove the VE state when the mod is unloading.
Events:Subscribe('Extension:Unloading', function()
	removebNight()
end)