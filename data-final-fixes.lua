local artificial_tiles = {}
for name, tile in ipairs(data.raw["tile"]) do
    if tile.subgroup and tile.subgroup == "artificial-tiles" then
        artificial_tiles[name] = tile
    end
end

-- getting tiles
local allowed_tiles = data.raw["plant"]["tree-plant"].autoplace["tile_restriction"]
local all_tiles = data.raw["tile"]

local allowed_tiles_lookup = {}
for _, name in ipairs(allowed_tiles or {}) do
    allowed_tiles_lookup[name] = true
end

if settings.startup["treenade_drop_on_concrete"].value then
    for name, tile in pairs(artificial_tiles) do
        allowed_tiles_lookup[name] = true
    end
end



-- to allow plant to only spawn on valid ones
for _, tile in pairs(all_tiles) do
    if tile and tile.collision_mask then
        if not allowed_tiles_lookup[tile.name] then
            tile.collision_mask.layers["layer_treenade"] = true
        else
            tile.collision_mask.layers["layer_treenade"] = nil
        end
    end
end
if not (settings.startup["treenade_drop_on_concrete"].value) then
    for name, tile in pairs(artificial_tiles) do
        if tile and tile.collision_mask then
            tile.collision_mask.layers["layer_treenade"] = true
        end
    end
end
data.raw["tile"]["nuclear-ground"].collision_mask.layers["layer_treenade"] = true
