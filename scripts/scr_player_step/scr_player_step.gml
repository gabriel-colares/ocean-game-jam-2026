function pl_step() {
  if (hp <= 0 || pl_dead) {
    is_attacking = false;
    is_shooting = false;
    hsp = 0;
    vsp = 0;
    pl_step_collision();
    exit;
  }
  pl_step_reacquire_gamepad();
  pl_step_input();
  pl_step_direction_lock();
  pl_step_cooldowns();
  pl_step_action_start();
  pl_step_animation();
  pl_step_movement();
  pl_step_collision();
}
