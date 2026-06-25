local self = {}
local market_manager = require(game.ReplicatedStorage.Shared.Libraries.MarketManager)
local data_manager = require(game.ServerScriptService.Server.Data.DataManager)

function self.initialize()
	market_manager.ProcessPass()
end

function self.start()
    for _, plr in game.Players:GetPlayers() do OnPlayerAdded(plr) end
	game.Players.PlayerAdded:Connect(function(plr) OnPlayerAdded(plr) end)
end

function OnPlayerAdded(plr)
    data_manager.WaitForData(plr)
    local player = shared.Player.new(plr)
    local player_data = data_manager.profiles[plr].Data
    player.Data = player_data
    market_manager.InitializeOwnedPass(plr)
end

return self
