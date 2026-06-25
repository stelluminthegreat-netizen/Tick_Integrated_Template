task.wait(0.25)
local player_obj = shared.Player
local Players = player_obj.Players
local dataManager = {}

dataManager.profiles = {}

function  dataManager.UpdateLeaderstats(plrName, statsName, changes)
	player_obj.WaitForPlayer(plrName)
	local player = Players[plrName].Player
	dataManager.WaitForData(player)
	changes(player, statsName)
end

function dataManager.RespondToDataRequest()
	local remoteEvent = game.ReplicatedStorage.Remotes.Events.UpdatePlayerData
	remoteEvent.OnServerEvent:Connect(function(plr)
		dataManager.UpdatePlayerData(plr)
	end)
end

function dataManager.UpdatePlayerData(plr)
	local remoteEvent = game.ReplicatedStorage.Remotes.Events.UpdatePlayerData
	dataManager.WaitForData(plr)
	remoteEvent:FireClient(plr, plr, dataManager.profiles[plr].Data)
end

function dataManager.WaitForData(plr)
	local data 
	while not data do
		task.wait()
		data = dataManager.profiles[plr]
	end
end

return dataManager