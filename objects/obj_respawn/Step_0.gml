global.respawn_room = room;
global.respawn_x = x;
global.respawn_y = y;

var p = instance_find(obj_player, 0);
if (global.respawn_apply && instance_exists(p)) {
  p.x = x;
  p.y = y;
  if (variable_global_exists("player_hp") && variable_instance_exists(p, "hp")) p.hp = global.player_hp;
  if (variable_instance_exists(p, "pl_dead")) p.pl_dead = false;
  global.respawn_apply = false;
}

if (!instance_exists(p)) exit;

var dead = false;
if (variable_instance_exists(p, "pl_dead") && p.pl_dead) dead = true;
if (variable_instance_exists(p, "hp") && p.hp <= 0) dead = true;

if (!dead) {
  respawn_t = 0;
  global.respawn_restarting = false;
  exit;
}

if (global.respawn_restarting) exit;

if (respawn_t <= 0) respawn_t = respawn_delay_steps;
respawn_t--;

if (respawn_t <= 0) {
  global.respawn_apply = true;
  global.respawn_restarting = true;
  if (!variable_global_exists("player_respawn_hp")) global.player_respawn_hp = 1;
  global.player_hp = global.player_respawn_hp;
  room_restart();
}
