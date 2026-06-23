local minor_tasks_handler = {}
local remote = game.ReplicatedStorage.Remote

function minor_tasks_handler.Start()
    remote.OnClientEvent:Connect(function(func, ...)
        local Func = minor_tasks_handler[func]
        if not Func then warn("Function not found.", func) return end
        Func(...)
    end)
end

return minor_tasks_handler