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
  #endregion
}
