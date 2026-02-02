#region INIT DIR/VISUAL
if (!inited) {
  inited = true;

  vx = 0;
  vy = 0;
  image_angle = 0;
  image_xscale = 1;

  switch (dir) {
    case 0:
      vx = 0; vy = 1;
      sprite_index = spr_lanca_down;
      break;
    case 1:
      vx = -1; vy = 0;
      sprite_index = spr_lanca_left;
      break;
    case 2:
      vx = 1; vy = 0;
      sprite_index = spr_lanca_left;
      image_xscale = -1;
      break;
    case 3:
      vx = 0; vy = -1;
      sprite_index = spr_lanca_up;
      break;
  }
}
#endregion

#region HIT ENEMY
var e = collision_circle(x, y, 6, obj_enemy_base, false, true);
if (instance_exists(e)) {
  var did = false;
  if (variable_instance_exists(e, "en_take_damage")) did = e.en_take_damage(dmg);

  if (did && variable_instance_exists(e, "cfg") && is_struct(e.cfg)) {
    if (variable_struct_exists(e.cfg, "kind") && e.cfg.kind == "nita") {
      if (!variable_instance_exists(e, "slow_mult")) e.slow_mult = 0.55;
      if (!variable_instance_exists(e, "slow_t")) e.slow_t = 0;
      e.slow_t = max(e.slow_t, ceil(room_speed * 0.75));
    }
  }

  if (did) {
    if (!variable_global_exists("cam_shake_t")) global.cam_shake_t = 0;
    if (!variable_global_exists("cam_shake_mag")) global.cam_shake_mag = 0;
    if (!variable_global_exists("cam_shake_tmax")) global.cam_shake_tmax = 0;
    var st = max(1, ceil(room_speed * 0.12));
    if (st > global.cam_shake_t) { global.cam_shake_t = st; global.cam_shake_tmax = st; }
    global.cam_shake_mag = max(global.cam_shake_mag, 3);

    if (irandom(2) == 0) {
      var fx_col = make_color_rgb(210, 210, 210);
      for (var i_fx = 0; i_fx < 2; i_fx++) {
        effect_create_above(ef_spark, e.x + random_range(-2, 2), e.y + random_range(-2, 2), random_range(0.35, 0.55), fx_col);
      }
    }
  }

  instance_destroy();
  exit;
}
#endregion

#region LIFE
life--;
if (life <= 0) { instance_destroy(); exit; }
#endregion

#region MOVIMENTO + COLISÃO (pixel-step)
var mx = round(vx * spd);
var my = round(vy * spd);

if (solid_obj != -1) {
  var sx = sign(mx);
  repeat (abs(mx)) {
    if (!place_meeting(x + sx, y, solid_obj)) x += sx;
    else { instance_destroy(); exit; }
  }

  var sy = sign(my);
  repeat (abs(my)) {
    if (!place_meeting(x, y + sy, solid_obj)) y += sy;
    else { instance_destroy(); exit; }
  }
} else {
  x += mx;
  y += my;
}
#endregion
