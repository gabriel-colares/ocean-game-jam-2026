/// scr_player_step_collision.gml
function pl_step_collision() {
  #region COLISÃO
  x_resto += hsp;
  y_resto += vsp;

  var mx = round(x_resto);
  var my = round(y_resto);

  x_resto -= mx;
  y_resto -= my;

  if (solid_obj != -1) {
    var sx = sign(mx);
    repeat (abs(mx)) {
      if (!place_meeting(x + sx, y, solid_obj)) x += sx;
      else { hsp = 0; x_resto = 0; break; }
    }

    var sy = sign(my);
    repeat (abs(my)) {
      if (!place_meeting(x, y + sy, solid_obj)) y += sy;
      else { vsp = 0; y_resto = 0; break; }
    }
  } else {
    x += mx;
    y += my;
  }

  var min_d = 14;
  for (var i = 0; i < 4; i++) {
    var e = collision_circle(x, y, min_d, obj_enemy_base, false, true);
    if (!instance_exists(e)) break;

    var dx = x - e.x;
    var dy = y - e.y;
    var d2 = dx * dx + dy * dy;
    if (d2 <= 0.001) { dx = 1; dy = 0; d2 = 1; }
    var d = sqrt(d2);
    var overlap = min_d - d;
    if (overlap <= 0) break;

    var nx = dx / d;
    var ny = dy / d;

    var px = round(nx * overlap);
    var py = round(ny * overlap);

    if (solid_obj != -1) {
      var sx2 = sign(px);
      repeat (abs(px)) {
        if (!place_meeting(x + sx2, y, solid_obj)) x += sx2;
        else break;
      }

      var sy2 = sign(py);
      repeat (abs(py)) {
        if (!place_meeting(x, y + sy2, solid_obj)) y += sy2;
        else break;
      }
    } else {
      x += px;
      y += py;
    }
  }
  #endregion
}
