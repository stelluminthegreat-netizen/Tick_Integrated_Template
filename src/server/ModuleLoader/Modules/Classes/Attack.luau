local class = {}
local RS = game:GetService("RunService")
local new_attack_event = game.ReplicatedStorage.Remotes.Events.NewAttack
local is_running = false
local attack_number = 0 -- Record used to give attacks a unique identifier
class.__index = class
class.Attacks = {}

--[[ 

- Attack attributes must include 
	- {
		Size: Vector3,
		StartPosition: Vector3,
		TargetPosition: Vector3,
		Speed: Number
		Type: String,
	}
--]]

function class.new(attributes)
	local self = setmetatable({}, class)
	self.Attributes = attributes
	self.Attributes.Direction = (self.Attributes.TargetPosition - self.Attributes.StartPosition).Unit	-- Direction of the attack
	self.Position = self.Attributes.StartPosition
	attack_number += 1 -- Increment to avoid having multiple attacks with same attack number
	self.AttackNumber = attack_number -- Unique identifier for the attack. Used to find the attack in class.Attacks
	self.Connections = {}
	self.Collided = shared.Event.new()
	self.Connections["Collision"] = self.Collided:Connect(self.Activate, self)
	self[self.Attributes.Type](self) -- Calls the method based on the attack type. 

	if is_running == false then -- Starts Run Service if not yet started
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
	params.FilterDescendantsInstances = {workspace.Trash} -- Filters the descendant of the instance/s in the table
	params.FilterType = Enum.RaycastFilterType.Exclude -- Set filter to ignore the filtered instances
	local in_range = game.Workspace:GetPartBoundsInBox(CFrame.new(position), self.Attributes.Size, params)
	return in_range
end

function class:Activate()
	--[[ Runs whatever the attack does ]]--
	if self.Activated and self.Activated == true then return end -- Debounce to avoid multiple runs
	print(self.AttackNumber)
	self.Activated = true
	warn("BAM!")
end

function class:Destroy()
	for _, attribute in self.Attributes do attribute = nil end
	for _, connection in self.Connections do connection:Disconnect() end
	class.Attacks[self.AttackNumber] = nil -- Removes itself from global attacks list
end

function BulkDetect(attacks: table)
	--[[ Calls Detect method on behalf of ALL attacks to avoid using multiple loops ]]--
	if #attacks == 0 then return end -- Debounce to avoid running if no attack is available
	for _, attack in attacks do
		local results = attack:Detect()
		if #results > 0 then attack.InRange = results attack.Collided:Fire() end
	end
end

function BulkMove(attacks: table, dt)
	--[[ Moves ALL attacks on their behalf to avoid using multiple loops ]]--
	if #attacks == 0 then warn(#attacks) return end
	for index, attack in attacks do
		attack.Position += (attack.Attributes.Direction * attack.Attributes.Speed)
	end
end

return class
