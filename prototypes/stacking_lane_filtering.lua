local Utils = require("__aai-loaders-stacking-filtering__.prototypes.base")
local Stacking = require("stacking")
local LaneFiltering = require("lane_filtering")

local function make_stacking_lane_filtering(entity, item, tech_override)
    local orig_item = data.raw["item"][item.name]

    -- Here, entity/item is still the non-stacking/filtering loader
    local duped_protos = Utils.dupe_loader(entity, item, "stacking-lane-filtering", "c")
    entity = duped_protos.entity
    item = duped_protos.item

    Stacking.set_stats(entity)
    Stacking.attach_icon(item, entity)
    LaneFiltering.set_stats(entity)
    local splitter_item_name = LaneFiltering.get_splitter_item_name(orig_item.name)
    LaneFiltering.attach_splitter_icon(item, splitter_item_name, entity)
    local recipe = LaneFiltering.generate_recipe(item, orig_item.name .. "-stacking", splitter_item_name)

    local protos = { recipe }
    for _, v in pairs(duped_protos) do
        table.insert(protos, v)
    end
    return protos
end

return make_stacking_lane_filtering
