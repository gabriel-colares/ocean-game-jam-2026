/// scr_player_init_animation.gml
function pl_init_animation() {
  #region ANIMAÇÃO
  sprIdleDownNoMask = sprPlayerIdleDown;
  sprIdleUpNoMask   = sprPlayerIdleUp;
  sprIdleSideNoMask = sprPlayerIdleLeft;

  sprRunDownNoMask  = sprPlayerRunDown;
  sprRunUpNoMask    = sprPlayerRunUp;
  sprRunSideNoMask  = sprPlayerRunLeft;

  sprIdleDownMask = sprPlayerMaskIdleDown;
  sprIdleUpMask   = sprPlayerMaskIdleUp;
  sprIdleSideMask = sprPlayerMaskIdleLeft;

  sprRunDownMask  = sprPlayerMaskRunDown;
  sprRunUpMask    = sprPlayerMaskRunUp;
  sprRunSideMask  = sprPlayerMaskRunLeft;

  sprAtkDownMask  = sprPlayerMaskAttackDown;
  sprAtkUpMask    = sprPlayerMaskAttackUp;
  sprAtkSideMask  = sprPlayerMaskAttackLeft;

  sprDeadNoMask = asset_get_index("sprPlayerDead");
  sprDeadMask   = asset_get_index("sprPlayerMaskDead");

  self.pl_set_mask = function(_has_mask) {
    pl_has_mask = _has_mask;

    if (pl_has_mask) {
      sprIdleDown = sprIdleDownMask;
      sprIdleUp   = sprIdleUpMask;
      sprIdleSide = sprIdleSideMask;

      sprRunDown  = sprRunDownMask;
      sprRunUp    = sprRunUpMask;
      sprRunSide  = sprRunSideMask;

      sprAtkDown  = sprAtkDownMask;
      sprAtkUp    = sprAtkUpMask;
      sprAtkSide  = sprAtkSideMask;
    } else {
      sprIdleDown = sprIdleDownNoMask;
      sprIdleUp   = sprIdleUpNoMask;
      sprIdleSide = sprIdleSideNoMask;

      sprRunDown  = sprRunDownNoMask;
      sprRunUp    = sprRunUpNoMask;
      sprRunSide  = sprRunSideNoMask;

      sprAtkDown  = sprAtkDownMask;
      sprAtkUp    = sprAtkUpMask;
      sprAtkSide  = sprAtkSideMask;
    }

    mask_index = sprRunDown;
  };

  self.pl_set_mask(false);

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
