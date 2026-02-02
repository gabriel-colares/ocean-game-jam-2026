#region INIT DIR/VISUAL
if (!inited) {
  inited = true;

  vx = 0;
  vy = 0;

  switch (dir) {
    case 0: vx = 0;  vy = 1;  image_angle = 90;  break; // down
    case 1: vx = -1; vy = 0;  image_angle = 180; break; // left
    case 2: vx = 1;  vy = 0;  image_angle = 0;   break; // right
    case 3: vx = 0;  vy = -1; image_angle = 270; break; // up
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
