
script.on_event(defines.events.on_trigger_created_entity, function(event)
    
    --local nuketile = prototypes.tile["nuclear-ground"];
    if event.entity.name == "tree-plant-dummy" then
        catalogue_concrete()
        entity = event.entity
        if (entity.valid) then
            local tile = entity.surface.get_tile(entity.position.x, entity.position.y)
            --game.print(tile.name)
            if (not (tile.name == "nuclear-ground")) then
                --game.print("k")
                if (storage.treenade_concrete_tiles[tile.name]) then
                    if (settings.global["treenade_drop_on_concrete"].value) then
                        local items = entity.surface.spill_item_stack({
                            stack = {name = "tree-seed"},
                            position = entity.position,
                            allow_belts = false,
                            enable_looted = true
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

function catalogue_concrete()
    if storage.treenade_concrete_tiles == nil then
        storage.treenade_concrete_tiles = {} 
        storage.treenade_concrete_tiles["concrete"] = true
        storage.treenade_concrete_tiles["refined-concrete"] = true
        storage.treenade_concrete_tiles["hazard-concrete-left"] = true
        storage.treenade_concrete_tiles["hazard-concrete-right"] = true
        storage.treenade_concrete_tiles["refined-hazard-concrete-right"] = true
        storage.treenade_concrete_tiles["refined-hazard-concrete-right"] = true
        storage.treenade_concrete_tiles["foundation"] = true
    end
end