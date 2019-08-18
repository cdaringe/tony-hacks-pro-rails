RAIL_DIRECTIONS = { defines.rail_direction.front, defines.rail_direction.back }
SIMILAR_DIRECTIONS = {
  -- north-ish vectors
  {
    defines.direction.north,
    defines.direction.northeast,
    defines.direction.northwest
  },
  -- northwest-ish vectors
  {
    defines.direction.north,
    defines.direction.northwest,
    defines.direction.west
  },
  -- west-ish vectors
  {
    defines.direction.west,
    defines.direction.northwest,
    defines.direction.southwest
  },
  -- southwest-ish vectors
  {
    defines.direction.west,
    defines.direction.south,
    defines.direction.southwest
  },
  -- south-ish vectors
  {
    defines.direction.southwest,
    defines.direction.south,
    defines.direction.southeast
  },
  -- southeast-ish vectors
  {
    defines.direction.east,
    defines.direction.south,
    defines.direction.southeast
  },
  -- east-ish vectors
  {
    defines.direction.east,
    defines.direction.northeast,
    defines.direction.southeast
  },
  -- northeast-ish vectors
  {
    defines.direction.north,
    defines.direction.northeast,
    defines.direction.east
  }
}
function is_similar_bearing(d1, d2)
  local eq_d1 = function (d) return d == d1 end
  local eq_d2 = function (d) return d == d2 end
  return find(
    function(direction_set)
      return (
        some(eq_d1, direction_set) and
        some(eq_d2, direction_set)
      )
    end,
    SIMILAR_DIRECTIONS
  )
end

function get_next_rail_option(rail_direction)
  game.player.print(rail_direction)
  local preferred_rail = rail.get_connected_rail({
    rail_direction = rail_direction,
    rail_connection_direction = defines.rail_connection_direction.straight
  })
  if is_not_nil(preferred_rail) then return preferred_rail end
  game.player.print('get_next_rail_option # unhandled case')
end

function get_relative_direction(a, b)
  local ax = a[1]
  local ay = a[2]
  local bx = b[1]
  local by = b[2]
  local dx = bx - ax
  local dy = by - ay
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
  local next_rail_options = filter(is_not_nil, map(get_next_rail_option, RAIL_DIRECTIONS))
  local next_rail_options_with_directions_relative_to_player = map(
    function(rails)
      local direction = get_relative_direction(rails.current_rail, rails.next_rail)
      return { rail = rails.next_rail, direction = direction }
    end,
    map(
      function (next_rail) return { next_rail = next_rail, current_rail = rail  } end,
      next_rail_options
    )
  )
  -- test for strong match between player travel and rail relativity to player travel
  local next_rail = find(function(dir) return dir == player_direction end, next_rail_directions_relative_to_player)
  if next_rail == nil then
    -- test for weak match between player travel and rail relativity to player travel
    local next_rail_with_direction = find(
      function(rail_with_direction) return is_similar_bearing(player_direction, rail_with_direction.direction) end,
      next_rail_options_with_directions_relative_to_player
    )
    if is_not_nil(next_rail) then next_rail = next_rail_with_direction.rail end
  end
  if next_rail == nil then return nil end
  if next_rail == previous_next_rail then
    return nil
  end
  return next_rail
end

function get_rail_standing_on(player)
  return player.surface.find_entities_filtered({
    type = {'straight-rail', 'curved-rail'},
    position = player.position,
    radius = 1
  })[1]
end
