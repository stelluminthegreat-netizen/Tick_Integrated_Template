local self = {}

function self.initialize()
	
end

function self.start()
	StartMinorTasksHandler()
    StartDataManager()
end

function StartMinorTasksHandler()
    local minor_tasks_handler = require(game.ReplicatedStorage.Shared.Libraries.MinorTasksHandler)
    minor_tasks_handler.Start()
end

function StartDataManager()
    local data_manager = require(script.Parent.Parent.Parent.Parent.Data.DataManager)
    data_manager.Start()
end

return self
