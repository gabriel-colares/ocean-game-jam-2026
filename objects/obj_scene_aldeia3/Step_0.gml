if (place_meeting(x, y, obj_player)) {
  if (!variable_global_exists("player_respawn_hp")) global.player_respawn_hp = 1;

  if (variable_global_exists("player_has_mask") && global.player_has_mask) {
    global.player_respawn_hp = max(global.player_respawn_hp, 3);
  }

  global.player_hp = global.player_respawn_hp;
  room_goto(Aldeia_3);
}
