local dataManager = {}
dataManager.Profiles = {}
local updatePlayerData = game.ReplicatedStorage.Remotes.Events.UpdatePlayerData

function dataManager.Start()
    dataManager.ReceiveData()
end

function dataManager.RequestData(plr)
    updatePlayerData:FireServer(plr)
end

function dataManager.ReceiveData()
    updatePlayerData.OnClientEvent:Connect(function(plr, data)
        if not dataManager.Profiles[plr] then dataManager.Profiles[plr] = {} end
        dataManager.Profiles[plr].Data = data  
    end)
end

function dataManager.WaitForData(plr)
    local plr_data 
    while not plr_data do
        task.wait()
        plr_data = dataManager.Profiles[plr]
    end
end

return dataManager