function pl_init_orientation() {
  #region ORIENTAÇÃO
  // 0=down, 1=left, 2=right, 3=up
  facing = 0;

  anim_state = "idle";
  anim_dir = 0;
  dir_lock = false;
  last_mx = 0;
  last_my = 1;
  attack_lock_x = 0;
  attack_lock_y = 1;
  pl_debug = false;

  axis_lock = 0;        // 0=none, 1=horizontal, 2=vertical
  prev_wants_move = false;

  prev_left  = false;
  prev_right = false;
  prev_up    = false;
  prev_down  = false;
  #endregion
}
