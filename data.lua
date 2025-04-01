local tech = require("__space-age__.prototypes.technology")
local item_sounds = require("__base__.prototypes.item_sounds")
local sounds = require("__base__.prototypes.entity.sounds")
local explosion_animations = require("__base__.prototypes.entity.explosion-animations")

-- There should be a better way to lookup concrete
--[[ And there is
local concrete_tiles = {
  { "concrete", data.raw["tile"]["concrete"] },
  { "refined-concrete", data.raw["tile"]["refined-concrete"] },
  { "hazard-concrete-left", data.raw["tile"]["hazard-concrete-left"] },
  { "hazard-concrete-right", data.raw["tile"]["hazard-concrete-right"] },
  { "refined-hazard-concrete-left", data.raw["tile"]["refined-hazard-concrete-left"] },
  { "refined-hazard-concrete-right", data.raw["tile"]["refined-hazard-concrete-right"] },
  { "foundation", data.raw["tile"]["foundation"] },
}
--]]

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


data:extend({
  {
    type = "collision-layer",
    name = "layer_treenade"
  }
})

-- to allow plant to only spawn on valid ones
for _, tile in pairs(all_tiles) do
  if tile and tile.collision_mask then
    if not allowed_tiles_lookup[tile.name] then
      tile.collision_mask.layers["layer_treenade"] = true
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

-- action
local boom_action = {
  {
    type = "direct",
    action_delivery =
    {
      type = "instant",
      target_effects =
      {
        type = "create-entity",
        entity_name = "explosion"
      },
    },
  },
  {
    type = "cluster",
    cluster_count = settings.startup["treenade_seeds_per_nade"].value,
    distance = settings.startup["treenade_boom_radius"].value,
    distance_deviation = settings.startup["treenade_boom_radius"].value,
    action_delivery =
    {
      type = "projectile",
      projectile = "treenade_seed",
      direction_deviation = 6.283,
      starting_speed = 1,
      starting_speed_deviation = 0.7
    }
  }
}


-- entity
local dummy = {
  type = "plant",
  name = "tree-plant-dummy",
  collision_mask = {
    layers = {
      water_tile = true,
      layer_treenade = true,
      object = true,
      is_object = true,
      is_lower_object = true,
      ghost = true,
      lava_tile = true,
      rail = true,
      rail_support = true,
      empty_space = true
    },
    not_colliding_with_itself = true
  },
  growth_ticks = 9999999,
  --surface_conditions = {
  --  property = "pressure",
  --  min = 1000,
  --  max = 1000
  --},
  icon = "__space-age__/graphics/icons/tree-seed.png",
  -- icon_size = 64,
  flags = { "placeable-neutral", "player-creation", "placeable-off-grid" },
  selectable_in_game = false,

  collision_box = data.raw["plant"]["tree-plant"].collision_box,
  --collision_box = { { -0.2, -0.2 }, { 0.2, 0.2 } },
  pictures =
  {
    {
      filename = "__space-age__/graphics/icons/tree-seed.png",
      width = 64,
      height = 64,
      scale = 0.2
    },
  }
}
data:extend({ dummy })

-- projectile
local treenade_seed =
{
  type = "projectile",
  name = "treenade_seed",
  flags = { "not-on-map" },
  hidden = true,
  acceleration = 0.005,
  action =
  {
    type = "direct",
    action_delivery =
    {
      type = "instant",
      target_effects =
      {
        {
          type = "create-entity",
          show_in_tooltip = false,
          entity_name = "tree-plant-dummy",
          trigger_created_entity = true,
          check_buildability = true,
          find_non_colliding_position = true,
          tile_collision_mask =
          {
            layers = {
              water_tile = true,
              layer_treenade = true,
              object = true,
              is_object = true,
              is_lower_object = true,
              ghost = true,
              lava_tile = true,
              rail = true,
              rail_support = true,
              empty_space = true
            },
            not_colliding_with_itself = true
          },
        }
      }
    },
  },
  --light = { intensity = 0.1, size = 1 },
  animation =
  {
    filename = "__space-age__/graphics/icons/tree-seed-1.png",
    width = 64,
    height = 64,
    scale = 0.2,
    shift = util.by_pixel(0.5, 0.5),
    priority = "high"
  }
}
data:extend({ treenade_seed })

-- item
local treenade_item =
{
  type = "capsule",
  name = "treenade",
  icon = "__treenade__/graphics/icons/treenade.png",
  capsule_action =
  {
    type = "throw",

    attack_parameters =
    {
      type = "projectile",
      activation_type = "throw",
      ammo_category = "grenade",
      cooldown = 10,
      projectile_creation_distance = 0.6,
      range = 30,
      ammo_type =
      {
        target_type = "position",
        action =
        {
          {
            type = "direct",
            action_delivery =
            {
              type = "projectile",
              projectile = "treenade",
              starting_speed = 1
            }
          },
          {
            type = "direct",
            action_delivery =
            {
              type = "instant",
              target_effects =
              {
                {
                  type = "play-sound",
                  sound = sounds.throw_projectile
                },
                {
                  type = "play-sound",
                  sound = sounds.throw_grenade
                },
              }
            }
          }
        }
      }
    }
  },
  subgroup = "capsule",
  order = "g[treenade]",
  inventory_move_sound = item_sounds.grenade_inventory_move,
  pick_sound = item_sounds.grenade_inventory_pickup,
  drop_sound = item_sounds.grenade_inventory_move,
  stack_size = settings.startup["treenade_stack_size"].value,
  weight = (settings.startup["treenade_stack_size"].value / 100.0) * kg
}

data:extend({ treenade_item })

-- projectile
local treenade = {
  type = "projectile",
  name = "treenade",
  flags = { "not-on-map" },
  hidden = true,
  acceleration = 0.05,
  action = boom_action,
  light = { intensity = 0.25, size = 1 },
  animation =
  {
    filename = "__treenade__/graphics/entity/treenade/treenade.png",
    draw_as_glow = true,
    frame_count = 15,
    line_length = 8,
    animation_speed = 0.50,
    width = 48,
    height = 54,
    shift = util.by_pixel(0.5, 0.5),
    priority = "high",
    scale = 0.5
  },
  shadow =
  {
    filename = "__treenade__/graphics/entity/treenade/treenade-shadow.png",
    frame_count = 15,
    line_length = 8,
    animation_speed = 0.50,
    width = 50,
    height = 40,
    shift = util.by_pixel(2, 6),
    priority = "high",
    draw_as_shadow = true,
    scale = 0.5
  },
}
data:extend({ treenade })

--item
local treessile_item = {
  type = "ammo",
  name = "treessile",
  icon = "__treenade__/graphics/icons/treessile.png",
  ammo_category = "rocket",
  ammo_type =
  {
    target_type = "position",
    action =
    {
      type = "direct",
      action_delivery =
      {
        type = "projectile",
        projectile = "treessile",
        starting_speed = 0.3,
        source_effects =
        {
          type = "create-entity",
          entity_name = "explosion-hit"
        }
      }
    }
  },
  subgroup = "ammo",
  order = "d[rocket-launcher]-a[treenade]",
  inventory_move_sound = item_sounds.ammo_large_inventory_move,
  pick_sound = item_sounds.ammo_large_inventory_pickup,
  drop_sound = item_sounds.ammo_large_inventory_move,
  stack_size = settings.startup["treenade_stack_size"].value,
  weight = 200 * kg
}
data:extend({ treessile_item })

--entity
local treessile = table.deepcopy(data.raw["projectile"]["rocket"])
treessile.name = "treessile"
treessile.action = boom_action
treessile.animation = require("__base__.prototypes.entity.rocket-projectile-pictures").animation({ 0.75, 1.0, 0.2 })

data:extend({ treessile })


data:extend(
  {
    -- recipe
    {
      type = "recipe",
      name = "treenade",
      category = "crafting-with-fluid",
      subgroup = "nauvis-agriculture",
      allow_productivity = false,
      enabled = false,
      energy_required = 5,
      surface_conditions = { -- tree seeds can only be planted on nauvis
        {
          property = "pressure",
          min = 1000,
          max = 1000
        } },
      ingredients =
      {
        { type = "item",  name = "steel-plate",        amount = 3 },
        { type = "item",  name = "electronic-circuit", amount = 3 },
        { type = "item",  name = "explosives",         amount = 2 },
        { type = "item",  name = "tree-seed",          amount = settings.startup["treenade_seeds_per_nade"].value },
        { type = "fluid", name = "water",              amount = settings.startup["treenade_seeds_per_nade"].value * 10 }
      },
      results = { { type = "item", name = "treenade", amount = 1 } }
    },

    -- recipe
    {
      type = "recipe",
      name = "treessile",
      category = "crafting-with-fluid",
      subgroup = "nauvis-agriculture",
      allow_productivity = false,
      enabled = false,
      energy_required = 5,
      surface_conditions = { -- tree seeds can only be planted on nauvis
        {
          property = "pressure",
          min = 1000,
          max = 1000
        } },
      ingredients =
      {
        { type = "item",  name = "rocket",    amount = 1 },
        { type = "item",  name = "tree-seed", amount = settings.startup["treenade_seeds_per_nade"].value },
        { type = "fluid", name = "water",     amount = settings.startup["treenade_seeds_per_nade"].value * 10 }
      },
      results = { { type = "item", name = "treessile", amount = 1 } }
    },

    -- technology
    {
      type = "technology",
      name = "treenades",
      icon_size = 128,
      icon = "__treenade__/graphics/technology/treenades.png",
      prerequisites = { "explosives", "tree-seeding" },
      unit =
      {
        count = 1000,
        ingredients =
        {
          { "automation-science-pack",   1 },
          { "logistic-science-pack",     1 },
          { "chemical-science-pack",     1 },
          { "space-science-pack",        1 },
          { "agricultural-science-pack", 1 }
        },
        time = 60
      },
      effects =
      {
        {
          type = "unlock-recipe",
          recipe = "treenade"
        }
      },
      order = "a[wood-processing]-b[treenade]"
    },

    --technology
    {
      type = "technology",
      name = "treessiles",
      icon_size = 256,
      icon = "__treenade__/graphics/technology/treessiles.png",
      prerequisites = { "rocketry", "treenades" },
      unit =
      {
        count = 4000,
        ingredients =
        {
          { "automation-science-pack",   1 },
          { "logistic-science-pack",     1 },
          { "chemical-science-pack",     1 },
          { "space-science-pack",        1 },
          { "agricultural-science-pack", 1 }
        },
        time = 60
      },
      effects =
      {
        {
          type = "unlock-recipe",
          recipe = "treessile"
        }
      },
      order = "a[wood-processing]-b[treessile]"
    }
  })
