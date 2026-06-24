local self = {}

function self.initialize()
	
end

function self.start()
	game.Players.PlayerAdded:Connect(function(plr) OnPlayerAdded(plr) end)
end

function OnPlayerAdded(plr)
    local player = shared.Player.new(plr)
end

return self
