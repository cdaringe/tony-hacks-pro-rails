local util = require('src/util')
local filter = util.filter
local map = util.map
local find = util.find
local is_not_nil = util.is_not_nil
local to_json = util.to_json
local round0 = util.round0

local east = defines.direction.east
local north = defines.direction.north
local northeast = defines.direction.northeast
local northwest = defines.direction.northwest
local south = defines.direction.south
local southeast = defines.direction.southeast
local southwest = defines.direction.southwest
local west = defines.direction.west

local print = nil

local pro_rails = {}
local GRIND_SPEED = 10
local globals = {
  position_last_pos_x = nil,
  position_last_pos_y = nil,
  is_grinding = false,
  frames_since_grinding = 0,
  is_init = false,
  is_skateboarding_researched = false
}

RAIL_CONNECTION_DIRECTIONS = { defines.rail_connection_direction.straight, defines.rail_connection_direction.left, defines.rail_connection_direction.right }
RAIL_DIRECTIONS = { defines.rail_direction.front, defines.rail_direction.back }
SIMILAR_DIRECTIONS = {
  -- north-ish vectors
  [north] = {
    [north] = true,
    [northeast] = true,
    [northwest] = true
  },
  -- northwest-ish vectors
  [northwest] = {
    [northwest] = true,
    [north] = true,
    [west] = true
  },
  -- west-ish vectors
  [west] = {
    [west] = true,
    [northwest] = true,
    [southwest] = true
  },
  -- southwest-ish vectors
  [southwest] = {
    [southwest] = true,
    [west] = true,
    [south] = true
  },
  -- south-ish vectors
  [south] = {
    [south] = true,
    [southwest] = true,
    [southeast] = true
  },
  -- southeast-ish vectors
  [southeast] = {
    [southeast] = true,
    [east] = true,
    [south] = true
  },
  -- east-ish vectors
  [east] = {
    [east] = true,
    [northeast] = true,
    [southeast] = true
  },
  -- northeast-ish vectors
  [northeast] = {
    [northeast] = true,
    [north] = true,
    [east] = true
  }
}

function init(game)
  for _, force in pairs(game.forces) do
    if force.technologies["skateboarding"].researched then
      globals.is_skateboarding_researched = true
    end
  end
  globals.is_init = true
end

function is_similar_bearing(d1, d2)
  return find(
    function(direction_set)
      if direction_set[d1] and direction_set[d2] then return true else return false end
    end,
    SIMILAR_DIRECTIONS
  )
end

function get_next_rail_options(rail)
  local i = 1
  local rail_options = {}
  -- loop order _matters_. rail-connection-directions put straight connections
  -- as priority
  for _,rail_connection_direction in ipairs(RAIL_CONNECTION_DIRECTIONS) do
    for __,rail_direction in ipairs(RAIL_DIRECTIONS) do
      local option = rail.get_connected_rail({
        rail_direction = rail_direction,
        rail_connection_direction = rail_connection_direction
      })
      if option then
        -- print('rail option found: [rail_direction] ' .. dir_to_string(rail_direction) .. ' [rail_connection_direction]: ' .. dir_to_string(rail_connection_direction) .. ' (i: ' .. i .. ')')
        rail_options[i] = option
        i = i + 1
      end
    end
  end
  return rail_options
end

function dir_to_string(dir)
  if dir == north then return 'north' end
  if dir == northeast then return 'northeast' end
  if dir == east then return 'east' end
  if dir == southeast then return 'southeast' end
  if dir == south then return 'south' end
  if dir == southwest then return 'southwest' end
  if dir == west then return 'west' end
  if dir == northwest then return 'northwest' end
end

function get_relative_direction(a, b)
  local dx = round0(b.x - a.x)
  local dy = round0(b.y - a.y)
  local rel_dir = nil
  if dx == 0 and dy < 0 then rel_dir = north end
  if dx == 0 and dy > 0 then rel_dir = south end
  if dx > 0 and dy > 0 then rel_dir = southeast end
  if dx < 0 and dy > 0 then rel_dir = southwest end
  if dx < 0 and dy == 0 then rel_dir = west end
  if dx > 0 and dy == 0 then rel_dir = east end
  if dx < 0 and dy < 0 then rel_dir = northwest end
  if dx > 0 and dy < 0 then rel_dir = northeast end
  -- print('{ dir: ' .. dir_to_string(rel_dir) .. ', dx = ' .. dx .. ', dy = ' .. dy .. ' }')
  return rel_dir
end

function is_perpendicular(d1, d2)
  if (d1 == north or d1 == south) and (d2 == east or d2 == west) then return true end
  if (d1 == northeast or d1 == southwest) and (d2 == northwest or d2 == southeast) then return true end
  if (d1 == northwest or d1 == southeast) and (d2 == northeast or d2 == southwest) then return true end
  if (d1 == east or d1 == west) and (d2 == north or d2 == south) then return true end
  return false
end

function get_next_rail(player, rail)
  local player_direction = player.walking_state.direction
  -- print('player going: ' .. dir_to_string(player_direction) .. ' and rail going: ' .. dir_to_string(rail.direction))
  if is_perpendicular(player_direction, rail.direction) then
    -- print('player is perpendicular to rail')
    return
  end
  local next_rail_options = get_next_rail_options(rail)
  local next_rail_options_with_directions_relative_to_current_rail = map(
    function(next_rail)
      local direction = get_relative_direction(rail.position, next_rail.position)
      -- if direction then
      --   print('direction of rail relative: ' .. direction)
      -- else
      --   print('direction of rail relative: NO_DIRECTION PROBS SHOULD NEVER HAPPEN!')
      -- end
      return { rail = next_rail, direction = direction }
    end,
    next_rail_options
  )
  -- test for strong match between player travel and rail relativity to player travel
  local next_rail_with_direction = find(function(rail_with_direction) return rail_with_direction.direction == player_direction end, next_rail_options_with_directions_relative_to_current_rail)
  if next_rail_with_direction == nil then
    -- test for weak match between player travel and rail relativity to player travel
    next_rail_with_direction = find(
      function(rail_with_direction) return is_similar_bearing(player_direction, rail_with_direction.direction) end,
      next_rail_options_with_directions_relative_to_current_rail
    )
  end
  local next_rail = nil
  if is_not_nil(next_rail_with_direction) then
    next_rail = next_rail_with_direction.rail
    -- set player walking direction to match rail!
    player.walking_state.direction = next_rail_with_direction.direction
  end
  if #next_rail_options > 0 and next_rail == nil then
    -- print('found ' .. #next_rail_options .. ' options')
  end
  return next_rail
end

function get_rail_standing_on(player)
  -- print('north: ' .. north)
  -- print('northeast: ' .. northeast)
  -- print('east: ' .. east)
  -- print('southeast: ' .. southeast)
  -- print('south: ' .. south)
  -- print('southwest: ' .. southwest)
  -- print('west: ' .. west)
  -- print('northwest: ' .. northwest)
  return player.surface.find_entities_filtered({
    type = {'straight-rail', 'curved-rail'},
    position = player.position,
    radius = 2
  })[1]
end

function maybe_grind(player)
  if globals.is_skateboarding_researched ~= true then return end
  print = player.print
  local rail_standing_on = get_rail_standing_on(player)
  if rail_standing_on == nil then return end
  if is_perpendicular(player.walking_state.direction, rail_standing_on.direction) then return end
  -- local next_rail = pro_rails.get_next_rail(player, rail_standing_on)
  local loco = game.surfaces.nauvis.create_entity({
    name = 'skatetrain',
    position = rail_standing_on.position,
    direction = player.walking_state.direction,
    amount = 1,
    force = player.force,
    player = player
  })
  if loco == nil then return end
  loco.train.speed = GRIND_SPEED
  loco.set_driver(player)
  globals.is_grinding = true
  globals.locomotive = loco
  globals.player = player
  player.play_sound{path = 'ollie'}
end

function on_grind_end()
  globals.position_last_pos_x = nil
  globals.position_last_pos_y = nil
  globals.locomotive.destroy()
  globals.is_grinding = false
  globals.frames_since_grinding = 0
end

function on_tick(evt)
  if globals.is_skateboarding_researched ~= true then return end
  if globals.is_grinding == false then return end
  if globals.frames_since_grinding < 45 then globals.frames_since_grinding = globals.frames_since_grinding + 1 end
  if globals.frames_since_grinding == 45 then
    globals.frames_since_grinding = globals.frames_since_grinding + 1
    globals.player.play_sound{path = '5050'}
  else
    if evt.tick % 60 == 0 then globals.player.play_sound{path = '5050'} end
  end
  globals.locomotive.train.speed = GRIND_SPEED
  local player = globals.player
  if globals.position_last_pos_x ~= player.position.x or globals.position_last_pos_y ~= player.position.y then
    -- still grinding, bro
    globals.position_last_pos_x = player.position.x
    globals.position_last_pos_y = player.position.y
    return
  end
  on_grind_end()
end

function on_research_finished(research)
  if research.name == 'skateboarding' then
    globals.is_skateboarding_researched = true
  end
end

return {
  get_next_rail = get_next_rail,
  get_next_rail_options = get_next_rail_options,
  get_rail_standing_on = get_rail_standing_on,
  get_relative_direction = get_relative_direction,
  globals = globals,
  init = init,
  is_similar_bearing = is_similar_bearing,
  maybe_grind = maybe_grind,
  on_research_finished = on_research_finished,
  on_tick = on_tick
}
