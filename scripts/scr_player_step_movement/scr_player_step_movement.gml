/// scr_player_step_movement.gml
function pl_step_movement() {
  #region MOVIMENTO
  if (hitstun_steps > 0) {
    hsp = pl_approach(hsp, 0, knockback_decel);
    vsp = pl_approach(vsp, 0, knockback_decel);
    exit;
  }

  if (!is_attacking && !is_shooting) {
    var mag = sqrt(pl_ix*pl_ix + pl_iy*pl_iy);

    if (mag > 0) {
      var scale = (mag > 1) ? (1 / mag) : 1;

      var target_hsp = (pl_ix * scale) * (move_speed * min(mag, 1));
      var target_vsp = (pl_iy * scale) * (move_speed * min(mag, 1));

      hsp = pl_approach(hsp, target_hsp, accel_move);
      vsp = pl_approach(vsp, target_vsp, accel_move);
    } else {
      hsp = pl_approach(hsp, 0, decel_stop);
      vsp = pl_approach(vsp, 0, decel_stop);
    }
  } else {
    hsp = 0;
    vsp = 0;
  }
  #endregion
}
