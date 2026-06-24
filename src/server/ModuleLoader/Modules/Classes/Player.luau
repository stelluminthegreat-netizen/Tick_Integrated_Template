local class = {}
class.__index = class
class.Players = {}

function class.new(plr)
	local self = setmetatable({}, class)
	self.Player = plr
	self.Name = plr.Name
	class.Players[self.Name] = self
	
	return self
end

return class
