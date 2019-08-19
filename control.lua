local pro_rails = require('src/pro_rails')

local is_grinding = true
local prev_grinding_player_direction = nil

function maybe_grind(player)
  -- if we're grinding, disregard keyboard asks--set player direction to face the rail!
  if is_grinding and prev_grinding_player_direction then
    player.walking_state.direction = prev_grinding_player_direction
  end
  local rail_standing_on = pro_rails.get_rail_standing_on(player)
  if rail_standing_on == nil then
    -- player.print('no rail!')
    return
  end
  local next_rail = pro_rails.get_next_rail(player, rail_standing_on)
  if next_rail == nil then
    is_grinding = false
    prev_grinding_player_direction = nil
    return
  end
  is_grinding = true
  prev_grinding_player_direction = player.walking_state.direction
  player.teleport(next_rail.position)
end


function on_player_changed_position(evt)
  local player = game.players[evt.player_index]
  local status, err = pcall(function () maybe_grind(player) end)
  if err then
    player.print('ERROR:')
    player.print(err)
  end
end

script.on_event({defines.events.on_player_changed_position}, on_player_changed_position)
script.on_event(defines.events.on_player_cheat_mode_disabled, on_player_changed_position)
