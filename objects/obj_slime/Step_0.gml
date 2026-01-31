/// Step Event - obj_slime

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
if (state != 2) {
  if (state == 0) {
    if (has_player && dist <= aggro_range) state = 1;
  } else if (state == 1) {
    if (!has_player || dist > give_up_range) state = 0;
  }
}
#endregion

#region HIT PAUSE
if (hit_pause_timer > 0) {
  hit_pause_timer--;
  hsp = 0;
  vsp = 0;
  sl_set_sprite(sprIdle, 0);
  exit;
}
#endregion

#region HURT
if (state == 2) {
  // para durante dano
  hsp = sl_approach(hsp, 0, decel_stop);
  vsp = sl_approach(vsp, 0, decel_stop);

  // anima 6 frames (0..5)
  image_speed = 0;
  image_index = clamp(hurt_timer, 0, 5);
  hurt_timer++;

  if (hurt_timer >= hurt_hold_steps) {
    hurt_timer = 0;
    state = (has_player && dist <= give_up_range) ? 1 : 0;

    // volta pro walk
    sl_set_sprite(sprWalk, 0.20);
    image_index = 0;
  }

  // ainda aplica movimento residual (normalmente zero)
  x += hsp;
  y += vsp;
  exit;
}
#endregion

#region MOVE LOGIC (idle/chase)
var ix = 0;
var iy = 0;

if (state == 1 && has_player) {
  var len = sqrt(dx*dx + dy*dy);
  if (len > 0) { ix = dx / len; iy = dy / len; }
}

var target_hsp = ix * move_speed;
var target_vsp = iy * move_speed;

if (state == 1 && (ix != 0 || iy != 0)) {
  hsp = sl_approach(hsp, target_hsp, accel_move);
  vsp = sl_approach(vsp, target_vsp, accel_move);
} else {
  hsp = sl_approach(hsp, 0, decel_stop);
  vsp = sl_approach(vsp, 0, decel_stop);
}
#endregion

#region ANIM + FLIP
var moving = (abs(hsp) + abs(vsp) > 0.02);

if (!moving) {
  // idle: para no frame 0 do walk
  sl_set_sprite(sprIdle, 0);
} else {
  sl_set_sprite(sprWalk, 0.20);

  // decide eixo dominante só pra flip vertical opcional
  face_axis = (abs(hsp) >= abs(vsp)) ? 0 : 1;

  // horizontal: padrão é LEFT, direita = flip
  if (abs(hsp) > 0.02) {
    image_xscale = (hsp >= 0) ? -1 : 1;
  }

  // vertical opcional (se ficar feio, deixa false no Create)
  if (use_vertical_flip_for_up && face_axis == 1) {
    image_yscale = (vsp < 0) ? -1 : 1;
  } else {
    image_yscale = 1;
  }
}
#endregion

#region APPLY MOVE
x += hsp;
y += vsp;
#endregion

#region CONTACT DAMAGE
if (has_player && contact_damage > 0) {
  var pl_hit = instance_place(x, y, obj_player);
  if (pl_hit != noone) {
    var kx = 0;
    var ky = 0;
    var klen = sqrt(hsp*hsp + vsp*vsp);
    if (klen > 0.01) {
      kx = hsp / klen;
      ky = vsp / klen;
    } else if (has_player && dist > 0) {
      kx = dx / dist;
      ky = dy / dist;
    }

    if (pl_hit.pl_take_damage(contact_damage, kx, ky, hit_pause_steps)) {
      hit_pause_timer = hit_pause_steps;
    }
  }
}
#endregion
