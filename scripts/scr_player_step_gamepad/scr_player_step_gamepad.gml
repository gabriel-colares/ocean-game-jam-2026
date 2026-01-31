function pl_step_reacquire_gamepad() {
  if (pad_id == -1 || !gamepad_is_connected(pad_id)) {
    pad_id = pl_gamepad_find_first(pad_scan_max);
    if (pad_id != -1) gamepad_set_axis_deadzone(pad_id, pad_deadzone);
  }
}
