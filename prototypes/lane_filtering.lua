local Utils = require("__aai-loaders-stacking-filtering__.prototypes.base")

local LaneFiltering = require("__aai-loaders-stacking-filtering__.prototypes.lane_filtering")
local NLLaneFiltering = {}

function NLLaneFiltering.make_lane_filtering(entity, item, orig_item, tech_override)
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

return NLLaneFiltering
