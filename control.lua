function on_player_changed_position(evt)
  local player = game.players[evt.player_index]
  local rails = player.surface.find_entities_filtered({
    type = {'straight-rail', 'curved-rail'},
    position = player.position,
    radius = 1
  })
  print(rails)
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
end
script.on_event(defines.events.on_player_changed_position, on_player_changed_position)
-- onmove?, test for rail
-- get rail entity, query for connect rails
  -- get user direction, move player on rail, animating between entities in rail segment
  -- at end of segment, check for next segment, continue
  -- when grind is no longer held down, stop
