/// scr_player_step_cooldowns.gml
function pl_step_cooldowns() {
  #region COOLDOWN
  if (shoot_cooldown > 0) shoot_cooldown--;
  #endregion
}
