/// scr_player_step_cooldowns.gml
function pl_step_cooldowns() {
  #region COOLDOWN
  if (shoot_cooldown > 0) shoot_cooldown--;
  if (invuln_steps > 0) invuln_steps--;
  if (hitstun_steps > 0) hitstun_steps--;
  #endregion
}
