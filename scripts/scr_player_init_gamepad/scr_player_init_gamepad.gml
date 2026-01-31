/// scr_player_init_gamepad.gml
function pl_init_gamepad_config() {
  #region GAMEPAD CONFIG
  pad_deadzone  = 0.25;
  pad_scan_max  = 11;
  pad_use_dpad  = true;
  pad_use_stick = true;

  pad_btn_attack = gp_face1;
  pad_btn_shoot  = gp_face2;

  // runtime
  pad_id = -1;

  // tenta pegar um já conectado no momento do Create
  pad_id = pl_gamepad_find_first(pad_scan_max);

  if (pad_id != -1) {
    gamepad_set_axis_deadzone(pad_id, pad_deadzone);
  }
  #endregion
}
