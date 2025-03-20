for _, config in ipairs({
    { prefix = "extreme-" },
    { prefix = "ultimate-" },
    { prefix = "high-speed-" },
    mods["wood-logisitcs"] and { prefix = "wood-" } or {},
}) do
    if config.prefix then
        local balancer = data.raw["lane-splitter"][config.prefix .. "lane-splitter"]
        local splitter = data.raw["splitter"][config.prefix .. "splitter"]
        if balancer and splitter then balancer.belt_animation_set = splitter.belt_animation_set end
    end
end

if mods["wood-logistics"] then
    data.raw["lane-splitter"]["wood-lane-splitter"].next_upgrade = "lane-splitter"
    for _, ingredient in pairs(data.raw.recipe["lane-splitter"].ingredients) do
        if ingredient.name == "transport-belt" then ingredient.name = "wood-lane-splitter" end
    end
end
