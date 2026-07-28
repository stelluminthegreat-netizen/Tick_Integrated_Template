local TemplatePath = script.Parent.Parent.Data.Player.PlayerTemplate
local Table = require(game.ReplicatedStorage.Shared.Libraries.Table)

local class = {}
class.__index = class
class.Players = {}

function class.new(plr)
	local self = setmetatable(Table.DeepClone(require(TemplatePath)), class)
	self.Player = plr
	class.Players[plr.Name] = self
	shared.Threads:Spawn(function() self:Init() end)
	return self
end

function class:Init()
	for _, name in self.EventNames do
		local event = shared.Event.new()
		self.Events[name] = event
	end
	
	for _, name in self.FrameWorkFuncs do
		if not self[name] then continue end
		self[name](self)
	end
end

function class:GameStateListener()
	local conn
	conn = self.Events.Changed:Connect(function(params, changes)
		local conns = self.Connections
		if not conns["GameStateListener"] then conns["GameStateListener"] = conn end
		if changes ~= "GameState" then return end
		local GameStateChanged = game.ReplicatedStorage.Remotes.Events.GameStateChanged
		GameStateChanged:FireServer()
	end)
end


return class
