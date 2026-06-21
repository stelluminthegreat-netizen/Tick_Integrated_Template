local find = {}

function find.FindFirstAncestorWithTag(root_instance, tag)
    local parent = root_instance.Parent
    while true do
        if not parent then return nil end
        if parent:HasTag(tag) then return parent end
        parent = parent.Parent
    end
end

function find.FindFirstChildWithTag(root_instance, tag, recursive)
    local children = root_instance:GetChildren()
    for _, child in children do
        if child:HasTag(tag) then return child end
    end
    if recursive ~= true then return end

    for _, child in children do
        local target_child = find.FindFirstChildWithTag(child, tag, true)
        if target_child then return target_child end 
    end
end

return find