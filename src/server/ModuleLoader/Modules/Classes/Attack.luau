local class = {}
class.__index = class

function class.new(attributes)
	local self = setmetatable({}, class)
	self.Attributes = attributes

	return self
end

return class
