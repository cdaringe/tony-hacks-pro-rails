-- {
--   type = "unlock-recipe",
--   recipe = "skateboard"
-- },
-- {
--   type = "unlock-recipe",
--   recipe = "skateboard-wheel"
-- }

data:extend({
  {
    type = "technology",
    name = "skateboarding",
    icon = "__tony_hacks_pro_rails__/graphics/icon/skateboard_large.png",
    icon_size = 850,
    prerequisites={},
    effects = {},
    unit = {
      count = 100,
      ingredients = {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
      },
      time = 1
    },
    order = "c-a"
  }
})
