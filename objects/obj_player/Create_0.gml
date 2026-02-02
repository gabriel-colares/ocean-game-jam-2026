pl_ix = 0;
pl_iy = 0;
pl_wants_h = false;
pl_wants_v = false;
pl_wants_move = false;

pl_left_down  = false;
pl_right_down = false;
pl_up_down    = false;
pl_down_down  = false;

pl_atk_press = false;
pl_shoot_press = false;

pl_create();

if (!variable_global_exists("respawn_room")) {
  global.respawn_room = room;
  global.respawn_x = x;
  global.respawn_y = y;
  global.respawn_apply = false;
  global.respawn_restarting = false;
} else {
  if (!variable_global_exists("respawn_restarting")) global.respawn_restarting = false;
  if (!global.respawn_restarting) {
    global.respawn_room = room;
    global.respawn_x = x;
    global.respawn_y = y;
    global.respawn_apply = false;
  }
}

if (!instance_exists(obj_respawn)) {
  instance_create_layer(x, y, layer, obj_respawn);
}
