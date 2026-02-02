if (place_meeting(x, y, obj_player)) {
  global.player_has_mask = false;
  global.player_respawn_hp = 1;
  global.player_hp = 1;
  global.respawn_restarting = false;
  global.respawn_apply = false;
  global.respawn_target_active = false;
  room_goto_next();
}
