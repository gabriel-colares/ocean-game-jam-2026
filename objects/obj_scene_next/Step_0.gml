if (place_meeting(x, y, obj_player)) {
  var p = instance_place(x, y, obj_player);
  if (instance_exists(p)) {
    if (variable_instance_exists(p, "pl_has_mask")) global.player_has_mask = p.pl_has_mask;
    if (variable_instance_exists(p, "hp")) global.player_hp = max(1, p.hp);
    if (variable_instance_exists(p, "hp_max")) global.player_hp_max = max(1, p.hp_max);
  }

  if (!variable_global_exists("player_hp_max")) global.player_hp_max = 3;
  if (!variable_global_exists("player_respawn_hp")) global.player_respawn_hp = 1;
  if (!variable_global_exists("player_hp")) global.player_hp = global.player_respawn_hp;
  global.player_hp = max(1, global.player_hp);
  global.player_respawn_hp = max(global.player_respawn_hp, global.player_hp);
  global.respawn_restarting = false;
  global.respawn_apply = false;
  global.respawn_target_active = false;
  room_goto_next();
}
