-- require('prototypes.entity.projectiles');
require('prototypes.item')
require('prototypes.sounds')
require('prototypes.technology.technology')
require('prototypes.recipe.recipe')
require('prototypes.ammo-category')

local m = '__THPR__'

local skatetrain = table.deepcopy(data.raw.locomotive.locomotive)
skatetrain.name = 'skatetrain'
skatetrain.order = "sk"

-- for _, l in pairs( skatetrain.pictures.layers ) do
--   if l.apply_runtime_tint == true then
--     for i = 1, 8 do
--       l.filenames[i] = m .. "/graphics/battle_loco/mask-" .. i .. ".png"
--     end
--     for i = 1, 16 do
--       l.hr_version.filenames[i] = m .. "/graphics/battle_loco/hr-mask-" .. i .. ".png"
--     end
--     break
--   end
-- end

-- local layer = {
--   direction_count = 1,
--   height = 58,
--   width = 46,
--   lines_per_file = 1,
--   scale = 1,
--   slice = 0,
--   filename =  m .. '/graphics/character/' ..  '1_1.png'
-- }
-- skatetrain.pictures.layers = { layer }

data:extend({ skatetrain })
