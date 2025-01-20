


allowed_tiles_lookup = storage.treenade_allowed_tiles or {}
script.on_event(defines.events.on_trigger_created_entity, function(event)
    if event.entity.name == "tree-plant-dummy" then
        entity = event.entity
        if (entity.valid) then
            tile = entity.surface.get_tile(entity.position.x, entity.position.y)
            if (entity.collision_mask and not entity.collision_mask.layers[tile]) then
                entity.surface.create_entity {
                    name = prototypes.item["tree-seed"].plant_result,
                    position = entity.position,
                    force = "neutral"
                }
            end
            entity.destroy()
        end
    end
end)
