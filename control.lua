local pro_rails = require('src/pro_rails')

function on_player_changed_position(evt)
if pro_rails.globals.is_init ~= true then pro_rails.init(game) end
  local player = game.players[evt.player_index]
  local status, err = pcall(function () pro_rails.maybe_grind(player) end)
  if err then
    player.print('ERROR:')
    player.print(err)
  end
end

script.on_event({defines.events.on_tick}, pro_rails.on_tick)
script.on_event({defines.events.on_player_changed_position}, on_player_changed_position)
script.on_event(defines.events.on_player_cheat_mode_disabled, on_player_changed_position)
script.on_event(defines.events.on_research_finished, pro_rails.on_research_finished)
