local MPS = game:GetService("MarketplaceService")

local market_manager = {}

function market_manager.PromptProductPurchase(plr: Player, product_id: number)
    MPS:PromptProductPurchase(plr, product_id)
end

function market_manager.PromptGamePassPurchase(plr: Player, game_pass_id: number)
    MPS:PromptGamePassPurchase(plr, game_pass_id)
end

return market_manager