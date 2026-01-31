/// scr_player_step_actions.gml
function pl_step_action_start() {
  #region ACTION START
  if (!is_attacking && !is_shooting) {
    if (pl_shoot_press && shoot_cooldown <= 0) {
      self.pl_shoot_start();
      shoot_timer = 0;
    } else if (pl_atk_press) {
      self.pl_attack_start();
      attack_timer = 0;
    }
  }
  #endregion
}
