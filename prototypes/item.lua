data:extend({
  {
    type = "gun",
    name = "skateboard",
    icon = "__tony_hacks_pro_rails__/graphics/icon/skateboard_large.png",
    icon_size = 850,
    subgroup = "gun",
    order = "-a[military]",
    attack_parameters =
    {
      type = "projectile",
      ammo_category = "skate-ammo",
      explosion = "explosion-gunshot",
      cooldown = 0,
      movement_slow_down_factor = 0.456,
      damage_modifier = 1.678,
      projectile_creation_distance = 1.125,
      range = 50,
      sound = make_laser_sounds(),
    },
    stack_size = 1
  },
  {
    type = "ammo",
    name = "skateboard-wheel",
    icon = "__tony_hacks_pro_rails__/graphics/icon/wheel_small.png",
    icon_size = 128,
    -- flags = {"goes-to-main-inventory"},
    ammo_type =
    {
      category = "skate-ammo",
    },
    magazine_size = 25,
    subgroup = "ammo",
    order = "b[shotgun]-b[piercing]",
    stack_size = 100
  }
})
