local functions = require(script.Parent.Parent.Data.UI_Functions) 
local class = {}
class.__index = class

class.UIs = {}

function class.new(UI, parent)
	local self = setmetatable({}, class)
	self.Player = game.Players.LocalPlayer
	self.UI = UI:Clone()
	self.Connections = {}
	self.Attributes = UI:GetAttributes()
	class.UIs[self.UI.Name] = self
	if parent ~= nil then self.UI.Parent = self.Player.PlayerGui:WaitForChild(parent) self:Initialize() end -- Parent the UI instance if parent argument is not nil

	return self
end

function class:Initialize()
	self.UI.Parent = self.Player.PlayerGui:FindFirstChild(self.Attributes.Parent, true) -- Parent the UI instance to its predetermined parent attribute
	local i = 0
	for index, attribute in self.Attributes do
		i += 1															-- Loop through all UI object attributes
		local func = functions[self.Attributes["Function" .. i]]		-- Find its functions
		if func then func(self) end										-- If function is found, run it
	end
end

function class:Destroy()
	class.UIs[self.UI.Name] = nil
	self.UI:Destroy()
	self.Player = nil

	for _, conn in self.Connections do
		conn:Disconnect()
	end
end

return class