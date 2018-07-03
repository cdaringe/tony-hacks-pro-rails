data:extend({
  {
    type = "technology",
    name = "skateboarding",
    icon = "__THPR__/graphics/icon/skateboard_large.png",
    icon_size = 850,
    prerequisites={},
    effects = {
      {
        type = "unlock-recipe",
        recipe = "skateboard"
      },
      {
        type = "unlock-recipe",
        recipe = "skateboard-wheel"
      }
    },
    unit = {
      count = 100,
      ingredients = {
        {"science-pack-1", 1},
        {"science-pack-2", 1},
      },
      time = 15
    },
    order = "c-a"
  }
})
