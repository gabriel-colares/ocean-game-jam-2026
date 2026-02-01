/// Step Event - obj_skeleton

#region FIND PLAYER
var pl = instance_nearest(x, y, obj_player);
var has_player = instance_exists(pl);
#endregion

#region DISTANCE
var dx = 0;
var dy = 0;
var dist = 999999;

if (has_player) {
  dx = pl.x - x;
  dy = pl.y - y;
  dist = sqrt(dx*dx + dy*dy);
}
#endregion

#region STATE SWITCH (aggro)
if (state != 3) {
  if (state == 0) {
    if (has_player && dist <= aggro_range) state = 1;
  } else if (state == 1) {
    if (!has_player || dist > give_up_range) state = 0;
  }
}
#endregion

#region DEAD
if (state == 3) {
  hsp = 0;
  vsp = 0;
  sk_set_sprite(sprDead, 0);
  exit;
}
#endregion

#region ATTACK
if (state == 2) {
  hsp = sk_approach(hsp, 0, decel_stop);
  vsp = sk_approach(vsp, 0, decel_stop);

  sk_set_sprite(sk_sprite_attack(facing), 0);
  if (facing == 2) image_xscale = -1;
  else if (facing == 1) image_xscale = 1;
  else image_xscale = 1;

  attack_timer++;
  if (attack_timer >= attack_hold_steps) {
    attack_timer = 0;
    state = (has_player && dist <= give_up_range) ? 1 : 0;
  }

  x += hsp;
  y += vsp;
  exit;
}
#endregion

#region MOVE LOGIC (idle/chase)
var ix = 0;
var iy = 0;

if (state == 1 && has_player) {
  if (dist <= attack_range) {
    state = 2;
    attack_timer = 0;
    sk_update_facing(dx, dy);
    exit;
  }

  var len = dist;
  if (len > 0) { ix = dx / len; iy = dy / len; }
  sk_update_facing(dx, dy);
}

var target_hsp = ix * move_speed;
var target_vsp = iy * move_speed;

if (state == 1 && (ix != 0 || iy != 0)) {
  hsp = sk_approach(hsp, target_hsp, accel_move);
  vsp = sk_approach(vsp, target_vsp, accel_move);
} else {
  hsp = sk_approach(hsp, 0, decel_stop);
  vsp = sk_approach(vsp, 0, decel_stop);
}
#endregion

#region ANIM + FLIP
var moving = (abs(hsp) + abs(vsp) > 0.02);

if (moving) {
  sk_set_sprite(sk_sprite_walk(facing), walk_anim_speed);
} else {
  sk_set_sprite(sk_sprite_idle(facing), idle_anim_speed);
}

if (facing == 2) image_xscale = -1;
else if (facing == 1) image_xscale = 1;
else image_xscale = 1;
#endregion

#region APPLY MOVE
x += hsp;
y += vsp;
#endregion
