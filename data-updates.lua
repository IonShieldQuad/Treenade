local allowed_tiles = data.raw["plant"]["tree-plant"].autoplace["tile_restriction"]
local all_tiles = data.raw["tile"]

local allowed_tiles_lookup = {}
for _, name in ipairs(allowed_tiles) do
    allowed_tiles_lookup[name] = true
end

data:extend({
    {
        type = "collision-layer",
        name = "layer_treenade"
    }
})

for _, tile in pairs(all_tiles) do
    if tile and tile.collision_mask then
        if not allowed_tiles_lookup[tile.name] then
            tile.collision_mask.layers["layer_treenade"] = true
        end
    end
end

local dummy = data.raw["plant"]["tree-plant-dummy"]
if dummy and dummy.collision_mask then
    dummy.collision_mask.layers["layer_treenade"] = true
end
