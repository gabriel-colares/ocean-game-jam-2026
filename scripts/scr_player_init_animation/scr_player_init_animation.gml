/// scr_player_init_animation.gml
function pl_init_animation() {
  #region ANIMAÇÃO
  sprIdleDown = sprPlayerIdleDown;
  sprIdleUp   = sprPlayerIdleUp;
  sprIdleSide = sprPlayerIdleLeft;

  sprRunDown  = sprPlayerRunDown;
  sprRunUp    = sprPlayerRunUp;
  sprRunSide  = sprPlayerRunLeft;

  sprAtkDown  = sprPlayerAttackDown;
  sprAtkUp    = sprPlayerAttackUp;
  sprAtkSide  = sprPlayerAttackLeft;

  is_attacking = false;
  attack_timer = 0;
  attack_last  = 0;

  is_shooting  = false;
  shoot_timer  = 0;
  shoot_anim_last = 0;

  sprite_index = sprIdleSide;
  image_index  = 0;
  image_speed  = 0;
  image_xscale = 1;

  // RECOMENDADO: troque por um sprPlayerMask depois
  mask_index = sprPlayerRunDown;

  attack_hold_steps = 10;
  shoot_hold_steps  = 8;
  run_hold_steps    = 9;
  idle_hold_steps   = 12;
  idle_stop_hold    = 10;

  anim_hold       = run_hold_steps;
  anim_timer      = 0;
  idle_stop_timer = 0;
  #endregion
}
