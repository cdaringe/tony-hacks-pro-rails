require('src.util')
require('src.map')

local is_grinding = true
local previous_next_rail = nil

function maybe_grind(player)
  local rail_entity_standing_on = get_rail_standing_on(player)
  if rail_entity_standing_on == nil then return on_ungrind() end
  local next_rail = get_next_rail(rail_entity_standing_on, player.walking_state.direction)
  if next_rail == nil then
    return on_ungrind()
  end
  player.teleport(next_rail.position)
  previous_next_rail = next_rail
end

function on_ungrind()
  previous_next_rail = nil
end

function on_player_changed_position(evt)
  local player = game.players[evt.player_index]
  local status, err = pcall(function () maybe_grind(player) end)
  if is_not_nill(err) then
    print(status)
    print(err.code)
  end
end

script.on_event({defines.events.on_player_changed_position}, on_player_changed_position)
script.on_event(defines.events.on_player_cheat_mode_disabled, on_player_changed_position)
