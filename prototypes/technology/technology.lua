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
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
      },
      time = 15
    },
    order = "c-a"
  }
})
