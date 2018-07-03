data:extend({
  {
    type = "recipe",
    name = "skateboard",
    enabled = false,
    energy_required = 10,
    ingredients =
    {
      {"steel-plate", 4},
      {"skateboard-wheel", 4},
      {"wood", 10}
    },
    result = "skateboard"
  },
  {
    type = "recipe",
    name = "skateboard-wheel",
    enabled = false,
    energy_required = 6,
    ingredients =
    {
      {"steel-plate", 4},
      {"advanced-circuit", 1},
      {"battery", 2}
    },
    result = "skateboard-wheel"
  }
})
