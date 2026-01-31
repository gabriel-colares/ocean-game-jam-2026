function pl_init_orientation() {
  #region ORIENTAÇÃO
  // 0=down, 1=left, 2=right, 3=up
  facing = 0;

  axis_lock = 0;        // 0=none, 1=horizontal, 2=vertical
  prev_wants_move = false;

  prev_left  = false;
  prev_right = false;
  prev_up    = false;
  prev_down  = false;
  #endregion
}
