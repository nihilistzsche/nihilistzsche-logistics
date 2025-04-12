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
if mods["aai-loaders-stacking-filtering"] then
    local NLStacking = require("prototypes.stacking")
    local NLLaneFiltering = require("prototypes.lane_filtering")
    local make_stacking_lane_filtering =
        require("__aai-loaders-stacking-filtering__.prototypes.stacking_lane_filtering")

    local has_stack_inserter = feature_flags["space_travel"]
        and (data.raw["inserter"]["stack-inserter"] and true or false)

    local enable_stacking = settings.startup["aai-loaders-stacking-filtering-enable-stacking"].value
        and has_stack_inserter
    local enable_lane_filtering = settings.startup["aai-loaders-stacking-filtering-enable-lane-filtering"].value
    local enable_stacking_lane_filtering = settings.startup["aai-loaders-stacking-filtering-enable-stacking-lane-filtering"].value
        and enable_stacking

    local new_loaders = { "extreme", "ultimate", "high-speed" }
    if mods["wood-logistics"] then table.insert(new_loaders, "wood") end
    for _, loader_type in pairs(new_loaders) do
        local tech_override
        if mods["aai-loaders-sane"] and loader_type ~= "wood" then tech_override = loader_type .. "-logistics" end
        if enable_stacking then
            data:extend(
                NLStacking.make_stacking(
                    table.deepcopy(data.raw["loader-1x1"]["aai-" .. loader_type .. "-loader"]),
                    table.deepcopy(data.raw["item"]["aai-" .. loader_type .. "-loader"]),
                    enable_stacking_lane_filtering,
                    tech_override
                )
            )
        end
        if enable_lane_filtering then
            data:extend(
                NLLaneFiltering.make_lane_filtering(
                    table.deepcopy(data.raw["loader-1x1"]["aai-" .. loader_type .. "-loader"]),
                    table.deepcopy(data.raw["item"]["aai-" .. loader_type .. "-loader"]),
                    nil,
                    tech_override
                )
            )
        end
        if enable_stacking_lane_filtering then
            data:extend(
                make_stacking_lane_filtering(
                    table.deepcopy(data.raw["loader-1x1"]["aai-" .. loader_type .. "-loader"]),
                    table.deepcopy(data.raw["item"]["aai-" .. loader_type .. "-loader"])
                )
            )
        end
    end
end
