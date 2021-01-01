-- Code from https://github.com/kapraran/vu-compass by kapraran
-- Modified by GreatApo
isHud = false

Hooks:Install('UI:PushScreen', 999, function(hook, screen, graphPriority, parentGraph)
	local screen = UIGraphAsset(screen)

	-- only for debug
	-- print(screen.name)
	-- if screen.name == 'UI/Flow/Screen/PreRoundWaitingScreen' then
	--   hook:Return(nil)
	--   return
	-- end

	if screen.name == 'UI/Flow/Screen/IngameMenuMP' or screen.name == 'UI/Flow/Screen/SpawnScreenPC' then
		WebUI:ExecuteJS('window.hideUI();')
		isHud = false
	end

	if screen.name == 'UI/Flow/Screen/HudMPScreen' then
		WebUI:ExecuteJS('window.showUI();')
		isHud = true
	end
end)