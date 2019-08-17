function on_player_changed_surface(evt, cause)
  print(cause)
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
script.on_event(defines.events.on_pre_player_died, on_pre_death)
-- onmove?, test for rail
-- get rail entity, query for connect rails
  -- get user direction, move player on rail, animating between entities in rail segment
  -- at end of segment, check for next segment, continue
  -- when grind is no longer held down, stop
