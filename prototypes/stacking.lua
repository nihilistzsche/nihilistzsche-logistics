local Utils = require("__aai-loaders-stacking-filtering__.prototypes.base")
local Stacking = require("__aai-loaders-stacking-filtering__.prototypes.stacking")
local NLStacking = {}

function NLStacking.make_stacking(entity, item, include_lane_filters_in_tech, tech_override)
    local orig_item = data.raw["item"][item.name]
    local duped_protos = Utils.dupe_loader(entity, item, "stacking", "b")
    entity = duped_protos.entity
    item = duped_protos.item

    Stacking.set_stats(entity)
    Stacking.attach_icon(item, entity)

    local recipe = Stacking.generate_recipe(item, orig_item.name)

    local orig_tech = data.raw.technology[tech_override or orig_item.name]
    if not orig_tech.icons then
        orig_tech.icons = {
            { icon = orig_tech.icon, icon_size = orig_tech.icon_size },
        }
        orig_tech.icon = nil
        orig_tech.icon_size = nil
    end
    local technology = Stacking.generate_tech(item, orig_tech, include_lane_filters_in_tech)

    local protos = { technology, recipe }

    for _, v in pairs(duped_protos) do
        table.insert(protos, v)
    end
    return protos
end

return NLStacking
