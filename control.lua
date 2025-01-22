
script.on_event(defines.events.on_trigger_created_entity, function(event)
    if event.entity.name == "tree-plant-dummy" then
        entity = event.entity
        if (entity.valid) then
            entity.surface.create_entity {
                name = prototypes.item["tree-seed"].plant_result,
                position = entity.position,
                force = "neutral"
            }
        end
        entity.destroy()
    end
end)
