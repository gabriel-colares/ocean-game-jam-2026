/// scr_player_step_direction.gml
function pl_step_direction_lock() {
  #region DIREÇÃO
  if (!is_attacking && !is_shooting) {
    var left_press  = pl_left_down  && !prev_left;
    var right_press = pl_right_down && !prev_right;
    var up_press    = pl_up_down    && !prev_up;
    var down_press  = pl_down_down  && !prev_down;

    prev_left  = pl_left_down;
    prev_right = pl_right_down;
    prev_up    = pl_up_down;
    prev_down  = pl_down_down;

    if (pl_wants_move && !prev_wants_move) {
      if (right_press || left_press) axis_lock = 1;
      else if (down_press || up_press) axis_lock = 2;
      else axis_lock = pl_wants_h ? 1 : 2;
    }

    if (pl_wants_move) {
      if (axis_lock == 1) {
        if (pl_wants_h) facing = (pl_ix < 0) ? 1 : 2;
        else { axis_lock = 2; facing = (pl_iy < 0) ? 3 : 0; }
      } else {
        if (pl_wants_v) facing = (pl_iy < 0) ? 3 : 0;
        else { axis_lock = 1; facing = (pl_ix < 0) ? 1 : 2; }
      }
    } else axis_lock = 0;

    prev_wants_move = pl_wants_move;
  }
  #endregion
}
