local function format_any_value(obj, buffer)
  local _type = type(obj)
  if _type == "table" then
      buffer[#buffer + 1] = '{"'
      for key, value in next, obj, nil do
          buffer[#buffer + 1] = tostring(key) .. '":'
          format_any_value(value, buffer)
          buffer[#buffer + 1] = ',"'
      end
      buffer[#buffer] = '}' -- note the overwrite
  elseif _type == "string" then
      buffer[#buffer + 1] = '"' .. obj .. '"'
  elseif _type == "boolean" or _type == "number" then
      buffer[#buffer + 1] = tostring(obj)
  else
      buffer[#buffer + 1] = '"???' .. _type .. '???"'
  end
end
local function to_json(obj)
  if obj == nil then return "null" else
      local buffer = {}
      format_any_value(obj, buffer)
      return table.concat(buffer)
  end
end

local is_grinding = true

function get_next_rail(rail)
  return rail.get_connected_rail({
    rail_direction = defines.rail_direction.front,
    rail_connection_direction = defines.rail_connection_direction.straight
  })
end

function get_standing_rail(player)
  return player.surface.find_entities_filtered({
    type = {'straight-rail', 'curved-rail'},
    position = player.position,
    radius = 1
  })[1]
end

function on_player_changed_position(evt)
  local player = game.players[evt.player_index]
  local rail = get_standing_rail(player)
  if rail == nil then
    player.print('no rail found')
    return nil
  end
  local max_moves = 10
  -- while((get_standing_rail(player) ~= nil))
  -- do
    local next_rail = get_next_rail(rail)
    if next_rail == nil then
      player.print('whoops no rail')
      return
    end
    player.teleport(next_rail.position)
    player.print('aw sick!')
    max_moves = max_moves - 1
    if max_moves == 0 then
      player.print('too many dope grindz')
    end
  -- end
end
  -- local surface = game.surfaces[evt['surface_index']]
  -- if surface == nil then
  --   return nil
  -- end


  -- player = game.players[evt.player_index]
  -- local trains = player.surface.find_entities_filtered
  -- {
  --   area =
  --   {{player.position.x - SEARCH_RANGE, player.position.y - SEARCH_RANGE},
  --   {player.position.x + SEARCH_RANGE, player.position.y + SEARCH_RANGE}},
  --   type= "locomotive"
  -- }
  -- if #trains > 0 then
  --   player.character.health = 1
  -- end
-- end
script.on_event({defines.events.on_player_changed_position}, on_player_changed_position)
script.on_event(defines.events.on_player_cheat_mode_disabled, on_player_changed_position)
-- onmove?, test for rail
-- get rail entity, query for connect rails
  -- get user direction, move player on rail, animating between entities in rail segment
  -- at end of segment, check for next segment, continue
  -- when grind is no longer held down, stop
