var x1 = x - (w * 0.5);
var y1 = y - (h * 0.5);
var x2 = x + (w * 0.5);
var y2 = y + (h * 0.5);

if (!hit_once) {
  var p = collision_rectangle(x1, y1, x2, y2, obj_player, false, true);
  if (instance_exists(p)) {
    var kx = 0;
    var ky = 0;
    switch (facing) {
      case 0: kx = 0; ky = 1; break;
      case 3: kx = 0; ky = -1; break;
      case 1: kx = -1; ky = 0; break;
      case 2: kx = 1; ky = 0; break;
    }

    if (variable_instance_exists(p, "pl_take_damage")) {
      p.pl_take_damage(dmg, kx, ky);
    }

    hit_once = true;
    instance_destroy();
    exit;
  }
}

life--;
if (life <= 0) { instance_destroy(); exit; }
