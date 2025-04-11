local Utils = require("__aai-loaders-stacking-filtering__.prototypes.base")

local Stacking = {}

function Stacking.attach_icon(item, entity)
    table.insert(item.icons, {
        icon = data.raw["virtual-signal"]["signal-stack-size"].icon,
        icon_size = 64,
        scale = 0.5,
        shift = { -16, 16 },
    })
    entity.icons = table.deepcopy(item.icons)
end

function Stacking.set_stats(entity)
    entity.max_belt_stack_size = settings.startup["aai-loaders-stacking-filtering-stack-size"].value
end

function Stacking.generate_recipe(item, orig_item_name)
    return {
        name = item.name,
        type = "recipe",
        category = "crafting",
        order = item.order,
        enabled = false,
        ingredients = {
            { type = "item", name = orig_item_name, amount = 2 },
            { type = "item", name = "stack-inserter", amount = 8 },
            { type = "item", name = "processing-unit", amount = 2 },
        },
        results = {
            { type = "item", name = item.name, amount = 1 },
        },
    }
end

function Stacking.generate_tech(item, orig_tech, include_lane_filters)
    if not orig_tech.icons then
        orig_tech.icons = {
            { icon = orig_tech.icon, icon_size = orig_tech.icon_size }
        }
        orig_tech.icon = nil
        orig_tech.icon_size = nil
    end
    local technology = {
        type = "technology",
        name = item.name,
        effects = {
            { type = "unlock-recipe", recipe = item.name },
            include_lane_filters and { type = "unlock-recipe", recipe = item.name .. "-lane-filtering" } or nil,
        },
        prerequisites = { "stack-inserter", orig_tech.name },
        unit = table.deepcopy(data.raw["technology"]["stack-inserter"].unit),
        icons = table.deepcopy(orig_tech.icons),
    }
    table.insert(technology.icons, {
        icon = data.raw["item"]["stack-inserter"].icon,
        icon_size = 64,
        scale = 0.75,
        shift = { -32, 32 },
    })
    technology.unit.count = technology.unit.count / 2
    return technology
end

function Stacking.make_stacking(entity, item, include_lane_filters_in_tech, tech_override)
    local orig_item = data.raw["item"][item.name]
    local duped_protos = Utils.dupe_loader(entity, item, "stacking", "b")
    entity = duped_protos.entity
    item = duped_protos.item

    Stacking.set_stats(entity)
    Stacking.attach_icon(item, entity)

    local recipe = Stacking.generate_recipe(item, orig_item.name)

    local orig_tech = data.raw.technology[tech_override or orig_item.name]
    local technology = Stacking.generate_tech(item, orig_tech, include_lane_filters_in_tech)

    local protos = { technology, recipe }

    for _, v in pairs(duped_protos) do
        table.insert(protos, v)
    end
    return protos
end

return Stacking
