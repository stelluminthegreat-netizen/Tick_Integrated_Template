local class = {}
local RS = game:GetService("RunService")
local new_attack_event = game.ReplicatedStorage.Remotes.Events.NewAttack
local is_running = false
local attack_number = 0
class.__index = class
class.Attacks = {}

function class.new(attributes)
	local self = setmetatable({}, class)
	self.Attributes = attributes
	self.Attributes.Direction = (self.Attributes.TargetPosition - self.Attributes.StartPosition).Unit	
	self.Position = self.Attributes.StartPosition
	attack_number += 1
	self.AttackNumber = attack_number
	self.Connections = {}
	self.Collided = shared.Event.new()
	self.Connections["Collision"] = self.Collided:Connect(self.Activate, self)
	self[self.Attributes.Type](self)

	if is_running == false then
		is_running = true
		RS.Heartbeat:Connect(function(dt)
			BulkMove(class.Attacks, dt)
			BulkDetect(class.Attacks)
		end)
	end
	return self
end

function class:Moving()
	class.Attacks[self.AttackNumber] = self
end

function class:Detect()
	local position = self.Position
	-- local player_obj = self.Attributes.Player
	-- local character = player_obj.Character.Character
	local params = OverlapParams.new()
	params.FilterDescendantsInstances = {workspace.Trash}
	params.FilterType = Enum.RaycastFilterType.Exclude
	local in_range = game.Workspace:GetPartBoundsInBox(CFrame.new(position), self.Attributes.Size, params)
	return in_range
end

function class:Activate()
	if self.Activated and self.Activated == true then return end
	print(self.AttackNumber)
	self.Activated = true
	warn("BAM!")
end

function class:Destroy()
	for _, attribute in self.Attributes do
		attribute = nil
	end
	class.Attacks[self.AttackNumber] = nil
end

function BulkDetect(attacks: table)
	if #attacks == 0 then return end
	for _, attack in attacks do
		local results = attack:Detect()
		if #results > 0 then attack.InRange = results attack.Collided:Fire() end
	end
end

function BulkMove(attacks: table, dt)
	if #attacks == 0 then warn(#attacks) return end
	for index, attack in attacks do
		attack.Position += (attack.Attributes.Direction * attack.Attributes.Speed)
	end
end

return class
