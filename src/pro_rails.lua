local util = require('src/util')
local filter = util.filter
local map = util.map
local find = util.find
local is_not_nil = util.is_not_nil
local to_json = util.to_json

local print = nil

local pro_rails = {}

RAIL_DIRECTIONS = { defines.rail_direction.front, defines.rail_direction.back }
RAIL_DIRECTIONS = RAIL_DIRECTIONS
SIMILAR_DIRECTIONS = {
  -- north-ish vectors
  [defines.direction.north] = {
    [defines.direction.north] = true,
    [defines.direction.northeast] = true,
    [defines.direction.northwest] = true
  },
  -- northwest-ish vectors
  [defines.direction.northwest] = {
    [defines.direction.northwest] = true,
    [defines.direction.north] = true,
    [defines.direction.west] = true
  },
  -- west-ish vectors
  [defines.direction.west] = {
    [defines.direction.west] = true,
    [defines.direction.northwest] = true,
    [defines.direction.southwest] = true
  },
  -- southwest-ish vectors
  [defines.direction.southwest] = {
    [defines.direction.southwest] = true,
    [defines.direction.west] = true,
    [defines.direction.south] = true
  },
  -- south-ish vectors
  [defines.direction.south] = {
    [defines.direction.south] = true,
    [defines.direction.southwest] = true,
    [defines.direction.southeast] = true
  },
  -- southeast-ish vectors
  [defines.direction.southeast] = {
    [defines.direction.southeast] = true,
    [defines.direction.east] = true,
    [defines.direction.south] = true
  },
  -- east-ish vectors
  [defines.direction.east] = {
    [defines.direction.east] = true,
    [defines.direction.northeast] = true,
    [defines.direction.southeast] = true
  },
  -- northeast-ish vectors
  [defines.direction.northeast] = {
    [defines.direction.northeast] = true,
    [defines.direction.north] = true,
    [defines.direction.east] = true
  }
}
SIMILAR_DIRECTIONS = SIMILAR_DIRECTIONS
function is_similar_bearing(d1, d2)
  return find(
    function(direction_set)
      if direction_set[d1] and direction_set[d2] then return true else return false end
    end,
    SIMILAR_DIRECTIONS
  )
end

function get_next_rail_option(rail, rail_direction)
  local preferred_rail = rail.get_connected_rail({
    rail_direction = rail_direction,
    rail_connection_direction = defines.rail_connection_direction.straight
  })
  if is_not_nil(preferred_rail) then return preferred_rail end
  print('get_next_rail_option # unhandled case')
end

function get_relative_direction(a, b)
  local dx = b.x - a.x
  local dy = b.y - a.y
  if dx > 0 and dy > 0 then return defines.direction.southeast end
  if dx > 0 and dy == 0 then return defines.direction.south end
  if dx < 0 and dy > 0 then return defines.direction.southwest end
  if dx < 0 and dy == 0 then return defines.direction.west end
  if dx < 0 and dy < 0 then return defines.direction.northwest end
  if dx == 0 and dy < 0 then return defines.direction.north end
  if dx > 0 and dy < 0 then return defines.direction.northeast end
  return defines.direction.east
end

function get_next_rail(rail, player_direction)
  local next_rail_options = filter(
    is_not_nil,
    map(
      function(dir) return get_next_rail_option(rail, dir) end,
      RAIL_DIRECTIONS
    )
  )
  local next_rail_options_with_directions_relative_to_player = map(
    function(rails)
      local direction = get_relative_direction(rails.current_rail.position, rails.next_rail.position)
      return { rail = rails.next_rail, direction = direction }
    end,
    map(
      function (next_rail) return { next_rail = next_rail, current_rail = rail  } end,
      next_rail_options
    )
  )
  -- test for strong match between player travel and rail relativity to player travel
  local next_rail_with_direction = find(function(rail_with_direction) return rail_with_direction.direction == player_direction end, next_rail_options_with_directions_relative_to_player)
  if next_rail_with_direction == nil then
    -- test for weak match between player travel and rail relativity to player travel
    next_rail_with_direction = find(
      function(rail_with_direction) return is_similar_bearing(player_direction, rail_with_direction.direction) end,
      next_rail_options_with_directions_relative_to_player
    )
  end
  local next_rail = nil
  if is_not_nil(next_rail_with_direction) then next_rail = next_rail_with_direction.rail end
  if next_rail == nil then return nil end
  if next_rail == previous_next_rail then
    return nil
  end
  print(to_json(next_rail))
  return next_rail
end

function get_rail_standing_on(player)
  -- @TODO remove HACKS!
  print = player.print
  return player.surface.find_entities_filtered({
    type = {'straight-rail', 'curved-rail'},
    position = player.position,
    radius = 1
  })[1]
end

return {
  is_similar_bearing = is_similar_bearing,
  get_next_rail_option = get_next_rail_option,
  get_relative_direction = get_relative_direction,
  get_next_rail = get_next_rail,
  get_rail_standing_on = get_rail_standing_on
}
