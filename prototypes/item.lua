data:extend({
  {
    type = "gun",
    name = "skateboard",
    icon = "__THPR__/graphics/icon/skateboard_large.png",
    icon_size = 850,
    flags = {"goes-to-main-inventory"},
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
    icon = "__THPR__/graphics/icon/wheel_small.png",
    icon_size = 128,
    flags = {"goes-to-main-inventory"},
    ammo_type =
    {
      category = "skate-ammo",
      -- action =
      -- {
          -- type = "direct",
          -- repeat_count = 10,
          -- action_delivery =
          -- {
            -- type = "projectile",
            -- projectile = "Laser-Gun-Bullet",
          --   starting_speed = 2,
          --   direction_deviation = 0,
          --   range_deviation = 0,
          --   max_range = 40
          -- }
        -- }
    },
    magazine_size = 25,
    subgroup = "ammo",
    order = "b[shotgun]-b[piercing]",
    stack_size = 100
  }
})
