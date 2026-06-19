local physical_effects = {}

function physical_effects.KnockBack(character, direction, force, wait)
    local HRP = character:FindFirstChild("HumanoidRootPart")
    if not HRP then warn("HumanoidRootPart not found.") return end
    local velocity = HRP:FindFirstChild("LinearVelocity")
    if not velocity then
        velocity = Instance.new("LinearVelocity", HRP)
        velocity.Attachment0 = HRP.RootAttachment
    end
    velocity.MaxForce = force
    velocity.Enabled = false

    velocity.VectorVelocity = direction
    velocity.Enabled = true
    task.wait(1)
    velocity.Enabled = false

    return true
end

function physical_effects.Freeze(character, duration)
    local baseParts = {}
    for index, child in character:GetChildren() do
        if not child:IsA("BasePart") then continue end
        baseParts[child.Name] = child
    end
    for index, part in baseParts do part.Anchored = true end
    task.wait(duration)
    for index, part in baseParts do part.Anchored = false end
end

function physical_effects.Stun(character, duration)
    local humanoid = character.Humanoid
    local original_walk_speed = humanoid.WalkSpeed
    local original_jump_power = humanoid.JumpPower
    humanoid.WalkSpeed = 0
    humanoid.JumpPower = 0
    task.wait(duration)
    humanoid.WalkSpeed = original_walk_speed
    humanoid.JumpPower = original_jump_power
end

return physical_effects