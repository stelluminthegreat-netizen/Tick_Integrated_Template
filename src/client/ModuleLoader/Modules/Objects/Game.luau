local self = {}

function self.initialize()
	
end

function self.start()
	StartMinorTasksHandler()
end

function StartMinorTasksHandler()
    local minor_tasks_handler = require(game.ReplicatedStorage.Shared.Libraries.MinorTasksHandler)
    minor_tasks_handler.Start()
end

return self
