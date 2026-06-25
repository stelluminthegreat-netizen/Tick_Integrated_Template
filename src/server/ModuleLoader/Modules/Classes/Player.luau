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

function class.WaitForPlayer(plr_name)
	local player
	while not player do
		task.wait()
		player = class.Players[plr_name]
	end
end

return class
