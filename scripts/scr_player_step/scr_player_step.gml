function pl_step() {
  pl_step_reacquire_gamepad();
  pl_step_input();
  pl_step_direction_lock();
  pl_step_cooldowns();
  pl_step_action_start();
  pl_step_animation();
  pl_step_movement();
  pl_step_collision();
}
