/// scr_player_step_animation.gml
function pl_step_animation() {
  #region ANIMAÇÃO
  image_xscale = (facing == 2) ? -1 : 1;

  if (is_attacking) {
    var last = attack_last;
    if (last <= 0) {
      image_index = 0;
      attack_timer++;
      if (attack_timer >= attack_hold_steps) {
        attack_timer = 0;
        is_attacking = false;
        idle_stop_timer = idle_stop_hold;
      }
    } else {
      anim_hold = attack_hold_steps;
      pl_anim_update_range(0, last);
      if (floor(image_index) == 0 && anim_timer == 0) {
        is_attacking = false;
        idle_stop_timer = idle_stop_hold;
      }
    }

  } else if (is_shooting) {
    var lasts = shoot_anim_last;
    if (lasts <= 0) {
      image_index = 0;
      shoot_timer++;
      if (shoot_timer >= shoot_hold_steps) {
        shoot_timer = 0;
        is_shooting = false;
        idle_stop_timer = idle_stop_hold;
      }
    } else {
      anim_hold = shoot_hold_steps;
      pl_anim_update_range(0, lasts);
      if (floor(image_index) == 0 && anim_timer == 0) {
        is_shooting = false;
        idle_stop_timer = idle_stop_hold;
      }
    }

  } else if (pl_wants_move) {
    idle_stop_timer = 0;

    var spr_run = pl_sprite_run(facing);
    pl_anim_set(spr_run, 0, run_hold_steps);

    var last_run = sprite_get_number(sprite_index) - 1;
    if (last_run < 0) last_run = 0;

    if (last_run <= 0) image_index = 0;
    else pl_anim_update_range(0, last_run);

  } else {
    var spr_idle = pl_sprite_idle(facing);

    if (sprite_index != spr_idle) {
      pl_anim_set(spr_idle, 0, idle_hold_steps);
      idle_stop_timer = idle_stop_hold;
    }

    if (idle_stop_timer > 0) {
      idle_stop_timer--;
      image_index = 0;
      anim_timer  = 0;
    } else {
      var last_idle = sprite_get_number(sprite_index) - 1;

      if (last_idle <= 0) {
        image_index = 0;
      } else {
        if (floor(image_index) < 1) image_index = 1;
        anim_hold = idle_hold_steps;
        pl_anim_update_range(1, last_idle);
      }
    }
  }
  #endregion
}
