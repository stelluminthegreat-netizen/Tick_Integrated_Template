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

return physical_effects