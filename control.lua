script.on_event(defines.events.on_trigger_created_entity, function(event)
    --local nuketile = prototypes.tile["nuclear-ground"];
    if event.entity.name == "tree-plant-dummy" then
        
        
        --game.print("setting " .. tostring(settings.startup["treenade_drop_on_concrete"].value))
        
        
        entity = event.entity
        if (entity.valid) then
            local tile = entity.surface.get_tile(entity.position.x, entity.position.y)
            alltiles = prototypes.tile
            artificial_tiles = {}
            for name, t in pairs(alltiles) do
                if (t.subgroup and t.subgroup.name == "artificial-tiles") then
                    artificial_tiles[name] = t
                end
            end

            --[[ debug stuff
                for n, t in pairs(artificial_tiles) do
                cl = t.collision_mask.layers

                buf1 = "For " .. n
                for a, b in pairs(cl) do
                    buf1 = buf1 .. "\n" .. tostring(a) .. ": " .. tostring(b)
                end
                game.print(buf1)
            end--]]

            if (not (tile.name == "nuclear-ground")) then
                if (artificial_tiles[tile.name] ~= nil) then 
                    if (settings.startup["treenade_drop_on_concrete"].value) then
                        local items = entity.surface.spill_item_stack({
                            stack = {name = "tree-seed"},
                            position = entity.position,
                            allow_belts = false,
                            enable_looted = true,
                            force = entity.force,
                            max_radius = 5.0,
                        })
                    end
                else
                entity.surface.create_entity {
                name = prototypes.item["tree-seed"].plant_result,
                position = entity.position,
                force = "neutral"
                }
                end
            end
        end
        entity.destroy()
    end
end)
