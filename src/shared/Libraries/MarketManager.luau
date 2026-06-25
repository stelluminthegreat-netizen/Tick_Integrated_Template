local MPS = game:GetService("MarketplaceService")

local pass_functions = {}
local prod_functions = {}

local market_manager = {}

----------------------------------- SERVER SIDE -----------------------------------

function market_manager.AwardPass(plr, pass_id)
    local func = pass_functions[pass_id]
    if not func then warn("Award pass failed, function for ID " .. pass_id .. " not found.") return end
    return func(plr)
end
 
function market_manager.ProcessPass()
    MPS.PromptGamePassPurchaseFinished:Connect(function(plr, pass_id, bought)
        if bought == false then print("Purchase cancelled of " .. pass_id .. "cancelled.") return end
        if MPS:UserOwnsGamePassAsync(plr.UserId, pass_id) then print("Player already owns gamepass " .. pass_id) return end
        market_manager.AwardPass(plr, pass_id)
    end)
end

function market_manager.InitializeOwnedPass(plr)
    local players = shared.Player.Players
    local player = players[plr.Name]
    for index, func in pass_functions do
        local awarded = false
        if player.Data.Passes[index] == true then market_manager.AwardPass(plr, index) awarded = true end
        if MPS:UserOwnsGamePassAsync(plr.UserId, index) and awarded == false then market_manager.AwardPass(plr, index) end
    end
end



----------------------------------- CLIENT SIDE -----------------------------------

function market_manager.PromptProductPurchase(plr: Player, product_id: number)
    MPS:PromptProductPurchase(plr, product_id)
end

function market_manager.PromptGamePassPurchase(plr: Player, game_pass_id: number)
    MPS:PromptGamePassPurchase(plr, game_pass_id)
end



----------------------------------- PASS FUNCTIONS -----------------------------------

pass_functions[1889950861] = function(plr)
    local players = shared.Player.Players
    local player = players[plr.Name]
    local owns_pass = false
    if player.Data.Passes[1889950861] == true or MPS:UserOwnsGamePassAsync(plr.UserId, 1889950861) then owns_pass = true end
    warn("AWARDED!!!")
end

return market_manager