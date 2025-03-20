if mods["wood-logistics"] and mods["aai-loaders-sane"] then
    data.raw["technology"]["aai-wood-loader"] = nil
    table.insert(
        data.raw["technology"]["wood-logistics"].effects,
        { type = "unlock-recipe", recipe = "aai-wood-loader" }
    )
    for _, ingredient in pairs(data.raw.recipe["aai-loader"].ingredients) do
        if ingredient.name == "transport-belt" then
            ingredient.name = "aai-wood-loader"
            ingredient.amount = 1
        end
    end
end
