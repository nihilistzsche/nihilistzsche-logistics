if mods["wood-logistics"] then
    for _, recipe in pairs(data.raw.recipe) do
        if string.find(recipe.name, "aai-") and string.find(recipe.name, "loader") then
            for _, ingredient in pairs(recipe.ingredients) do
                if ingredient.name == "transport-belt" then
                    ingredient.name = "aai-wood-loader"
                    ingredient.amount = 1
                end
            end
        end
    end
end
if mods["aai-loaders-sane"] then
    if mods["wood-logistics"] then
        data.raw["technology"]["aai-wood-loader"] = nil
        table.insert(
            data.raw["technology"]["wood-logistics"].effects,
            { type = "unlock-recipe", recipe = "aai-wood-loader" }
        )
    end
    if mods["aai-loaders-stacking-filtering"] then
        for _, tech in pairs(data.raw.technology) do
            if
                string.find(tech.name, "aai-")
                and string.find(tech.name, "loader")
                and (string.find(tech.name, "stacking") or string.find(tech.name, "filtering"))
            then
                local base_name = tech.name:gsub(
                    "%S+",
                    { ["-stacking"] = "", ["-stacking-lane-filtering"] = "", ["-lane-filtering"] = "" }
                )
                data.raw.technology[tech.name] = nil
                for _, _tech in pairs(data.raw.technology) do
                    if _tech.effects then
                        for _, effect in pairs(_tech.effects) do
                            if effect.type == "unlock-recipe" and effect.recipe == base_name then
                                table.insert(_tech.effects, { type = "unlock-recipe", recipe = tech.name })
                            end
                        end
                    end
                end
            end
        end
    end
end
