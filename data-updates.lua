if settings.startup["treenade_drop_on_concrete"].value then
    local artificial_tiles = {}
    for name, tile in pairs(data.raw["tile"]) do
        if tile.subgroup and tile.subgroup == "artificial-tiles" then
            artificial_tiles[name] = tile
            if tile and tile.collision_mask then
                tile.collision_mask.layers["layer_treenade"] = nil
            end
        end
    end
    for name, tile in pairs(artificial_tiles) do
        if tile and tile.collision_mask then
            tile.collision_mask.layers["layer_treenade"] = nil
        end
    end
end



