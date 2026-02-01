draw_self();

if (!pl_debug) exit;

var ax = 0;
var ay = 0;

if (dir_lock) {
  ax = attack_lock_x;
  ay = attack_lock_y;
} else {
  ax = hsp;
  ay = vsp;
  if (abs(ax) + abs(ay) <= 0.02) {
    ax = last_mx;
    ay = last_my;
  }
}

var alen = sqrt(ax*ax + ay*ay);
if (alen > 0) {
  ax /= alen;
  ay /= alen;
}

draw_set_color(c_white);
draw_line(x, y, x + (ax * 12), y + (ay * 12));
draw_text(x + 10, y - 34, anim_state);
draw_text(x + 10, y - 22, string(anim_dir) + " " + string(image_xscale));
