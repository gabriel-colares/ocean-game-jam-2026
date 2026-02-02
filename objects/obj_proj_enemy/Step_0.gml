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

life--;
if (life <= 0) { instance_destroy(); exit; }

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

var p = collision_circle(x, y, 6, obj_player, false, true);
if (instance_exists(p)) {
  var kx = vx;
  var ky = vy;
  if (variable_instance_exists(p, "pl_take_damage")) p.pl_take_damage(dmg, kx, ky);
  instance_destroy();
  exit;
}
