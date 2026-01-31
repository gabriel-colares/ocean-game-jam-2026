/// scr_player_step_input.gml
function pl_step_input() {
  #region INPUT
  // --- teclado ---
  var k_left  = keyboard_check(key_left_primary)  || keyboard_check(key_left_alt);
  var k_right = keyboard_check(key_right_primary) || keyboard_check(key_right_alt);
  var k_up    = keyboard_check(key_up_primary)    || keyboard_check(key_up_alt);
  var k_down  = keyboard_check(key_down_primary)  || keyboard_check(key_down_alt);

  pl_atk_press   = keyboard_check_pressed(key_attack_primary) || keyboard_check_pressed(key_attack_alt);
  pl_shoot_press = keyboard_check_pressed(key_shoot_primary)  || keyboard_check_pressed(key_shoot_alt);

  // --- gamepad ---
  var gp_ok = (pad_id != -1);

  var gp_dleft = false, gp_dright = false, gp_dup = false, gp_ddown = false;
  var gp_lx = 0, gp_ly = 0;

  if (gp_ok) {
    if (pad_use_dpad) {
      gp_dup    = gamepad_button_check(pad_id, gp_padu);
      gp_ddown  = gamepad_button_check(pad_id, gp_padd);
      gp_dleft  = gamepad_button_check(pad_id, gp_padl);
      gp_dright = gamepad_button_check(pad_id, gp_padr);
    }

    if (pad_use_stick) {
      gp_lx = pl_apply_deadzone_axis(gamepad_axis_value(pad_id, gp_axislh), pad_deadzone);
      gp_ly = pl_apply_deadzone_axis(gamepad_axis_value(pad_id, gp_axislv), pad_deadzone);
    }

    pl_atk_press   = pl_atk_press   || gamepad_button_check_pressed(pad_id, pad_btn_attack);
    pl_shoot_press = pl_shoot_press || gamepad_button_check_pressed(pad_id, pad_btn_shoot);
  }

  // --- direção final (booleans) ---
  pl_left_down  = k_left  || gp_dleft  || (gp_lx < 0);
  pl_right_down = k_right || gp_dright || (gp_lx > 0);
  pl_up_down    = k_up    || gp_dup    || (gp_ly < 0);
  pl_down_down  = k_down  || gp_ddown  || (gp_ly > 0);

  // --- vetor de movimento (float) ---
  // prioridade: teclado > dpad > analógico
  var ix = 0;
  var iy = 0;

  if (k_left || k_right) ix = (k_right ? 1 : 0) - (k_left ? 1 : 0);
  else if (gp_dleft || gp_dright) ix = (gp_dright ? 1 : 0) - (gp_dleft ? 1 : 0);
  else ix = gp_lx;

  if (k_up || k_down) iy = (k_down ? 1 : 0) - (k_up ? 1 : 0);
  else if (gp_dup || gp_ddown) iy = (gp_ddown ? 1 : 0) - (gp_dup ? 1 : 0);
  else iy = gp_ly;

  pl_ix = ix;
  pl_iy = iy;

  pl_wants_h = (pl_ix != 0);
  pl_wants_v = (pl_iy != 0);
  pl_wants_move = pl_wants_h || pl_wants_v;
  #endregion
}
