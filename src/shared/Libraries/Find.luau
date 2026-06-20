local find = {}

function find.FindFirstAncestorWithTag(root_instance, tag)
    local parent = root_instance.Parent
    while true do
        if not parent then return nil end
        if parent:HasTag(tag) then return parent end
        parent = parent.Parent
    end
end

return find