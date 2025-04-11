local Utils = require("__aai-loaders-stacking-filtering__.prototypes.base")

local LaneFiltering = {}

local mod_integration_setting = settings.startup["aai-loaders-stacking-filtering-lane-splitter-integration"].value
local has_compatible_mod = (mods["lane-splitters"] and true or false) or (mods["lane-balancers"] and true or false)
local use_mod_integration = has_compatible_mod and mod_integration_setting

function LaneFiltering.get_splitter_item_name(loader_name)
    -- "aai-express-loader" -> "express"
    -- "aai-loader" -> ""
    local tier = string.sub(loader_name, 5, -8)

    -- "" -> ""
    -- "express" -> "express-"
    if #tier > 0 then tier = tier .. "-" end

    if use_mod_integration and data.raw["item"][tier .. "lane-splitter"] then
        -- "" -> "lane-splitter"
        -- "express-" -> "express-lane-splitter"
        tier = tier .. "lane-splitter"
    else
        tier = tier .. "splitter"
    end

    return tier
end

function LaneFiltering.set_stats(entity)
    entity.filter_count = 2
    entity.per_lane_filters = true
end

function LaneFiltering.attach_splitter_icon(item, splitter_id, entity)
    local icons = table.deepcopy(data.raw["item"][splitter_id].icons)
    if icons then
        for _, icondata in ipairs(icons) do
            icondata.scale = (icondata.scale or 1) * 0.5
            icondata.shift = icondata.shift or { -32, -32 }
            icondata.shift[1] = icondata.shift[1] * icondata.scale
            icondata.shift[2] = icondata.shift[2] * icondata.scale
            table.insert(item.icons, icondata)
        end
    else
        table.insert(item.icons, {
            icon = data.raw["item"][splitter_id].icon,
            icon_size = 64,
            scale = 0.5,
            shift = { -16, -16 },
        })
    end
    entity.icons = table.deepcopy(item.icons)
end

function LaneFiltering.generate_recipe(item, orig_item_name, splitter_item_name)
    return {
        name = item.name,
        type = "recipe",
        category = "crafting",
        order = item.order,
        enabled = false,
        ingredients = {
            { type = "item", name = orig_item_name, amount = 1 },
            { type = "item", name = splitter_item_name, amount = 2 },
        },
        results = {
            { type = "item", name = item.name, amount = 1 },
        },
    }
end

function LaneFiltering.insert_tech_recipe(tech_name, recipe_name)
    table.insert(data.raw["technology"][tech_name].effects, {
        type = "unlock-recipe",
        recipe = recipe_name,
    })
end

function LaneFiltering.make_lane_filtering(entity, item, orig_item, tech_override)
    orig_item = orig_item or data.raw["item"][item.name]
    local duped_protos = Utils.dupe_loader(entity, item, "lane-filtering", "a")
    entity = duped_protos.entity

    LaneFiltering.set_stats(entity)

    local splitter_item_name = LaneFiltering.get_splitter_item_name(orig_item.name)

    item = duped_protos.item
    LaneFiltering.attach_splitter_icon(item, splitter_item_name, entity)

    local recipe = LaneFiltering.generate_recipe(item, orig_item.name, splitter_item_name)

    LaneFiltering.insert_tech_recipe(tech_override or orig_item.name, recipe.name)

    local protos = { recipe }
    for _, v in pairs(duped_protos) do
        table.insert(protos, v)
    end
    return protos
end

return LaneFiltering
