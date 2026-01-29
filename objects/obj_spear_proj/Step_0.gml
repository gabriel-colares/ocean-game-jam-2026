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

  // se você tiver sprites por direção, é aqui que troca:
  // switch (dir) { case 0: sprite_index = sprSpearDown; break; ... }
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
