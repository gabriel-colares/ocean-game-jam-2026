/// scr_player_functions.gml

#region GAMEPAD HELPERS (globais)
function pl_gamepad_find_first(_scan_max) {
  for (var i = 0; i <= _scan_max; i++) {
    if (gamepad_is_connected(i)) return i;
  }
  return -1;
}

function pl_apply_deadzone_axis(v, dz) {
  if (abs(v) < dz) return 0;
  var s = sign(v);
  return s * ((abs(v) - dz) / (1 - dz));
}
#endregion

function pl_init_functions() {
  #region FUNÇÕES (helpers gerais)
  function pl_approach(_cur, _target, _step) {
    if (_cur < _target) return min(_cur + _step, _target);
    if (_cur > _target) return max(_cur - _step, _target);
    return _cur;
  }

  function pl_anim_set(_spr, _start_frame, _hold_steps) {
    if (sprite_index != _spr) {
      sprite_index = _spr;
      image_index  = _start_frame;
      image_speed  = 0;
      anim_timer   = 0;
    }
    anim_hold = _hold_steps;
  }

  function pl_anim_update_range(_first, _last) {
    image_speed = 0;

    anim_timer++;
    if (anim_timer >= anim_hold) {
      anim_timer = 0;

      var f = floor(image_index) + 1;
      if (f > _last) f = _first;
      image_index = f;
    }
  }

  function pl_sprite_idle(_f) {
    if (_f == 0) return sprIdleDown;
    if (_f == 3) return sprIdleUp;
    return sprIdleSide;
  }

  function pl_sprite_run(_f) {
    if (_f == 0) return sprRunDown;
    if (_f == 3) return sprRunUp;
    return sprRunSide;
  }

  function pl_sprite_attack(_f) {
    if (_f == 0) return sprAtkDown;
    if (_f == 3) return sprAtkUp;
    return sprAtkSide;
  }
  #endregion

  #region VIDA
  hp_max = 3;
  hp = 1;
  pl_dead = false;

  invuln_steps_max = max(1, ceil(room_speed * 0.2));
  invuln_steps = 0;

  hitstun_steps_max = max(1, ceil(room_speed * 0.2));
  hitstun_steps = 0;

  knockback_speed = 3.0;
  knockback_decel = 0.35;

  self.pl_is_invulnerable = function() {
    return invuln_steps > 0;
  };

  self.pl_is_dead = function() {
    return pl_dead;
  };

  self.pl_take_damage = function(_amount) {
    var _knock_x = 0;
    var _knock_y = 0;
    var _stun_steps = hitstun_steps_max;

    if (argument_count >= 2) _knock_x = argument[1];
    if (argument_count >= 3) _knock_y = argument[2];
    if (argument_count >= 4) _stun_steps = max(0, argument[3]);

    if (_amount <= 0) return false;
    if (hp <= 0 || pl_dead) return false;
    if (invuln_steps > 0) return false;

    hp = max(0, hp - _amount);
    invuln_steps = invuln_steps_max;
    hitstun_steps = max(hitstun_steps, _stun_steps);

    is_attacking = false;
    is_shooting  = false;

    if (hp <= 0) {
      pl_dead = true;
      hsp = 0;
      vsp = 0;
      x_resto = 0;
      y_resto = 0;
      invuln_steps = 0;
      hitstun_steps = 0;
      return true;
    }

    var klen = sqrt(_knock_x*_knock_x + _knock_y*_knock_y);
    if (klen > 0) {
      var kx = _knock_x / klen;
      var ky = _knock_y / klen;
      if (abs(kx) >= abs(ky)) facing = (kx < 0) ? 1 : 2;
      else facing = (ky < 0) ? 3 : 0;
      hsp = kx * knockback_speed;
      vsp = ky * knockback_speed;
      x_resto = 0;
      y_resto = 0;
    }

    return true;
  };
  #endregion

  #region HUD
  self.pl_draw_gui = function() {
    var margin = 12;
    var gap = 4;
    var sc = 2;

    var spr_full = spr_heart_full;
    var spr_empty = spr_heart_empty;

    var sw = sprite_get_width(spr_full);
    var x0 = margin;
    var y0 = margin;

    draw_set_alpha(1);
    for (var i = 0; i < hp_max; i++) {
      var spr = (i < hp) ? spr_full : spr_empty;
      draw_sprite_ext(spr, 0, x0 + i * ((sw * sc) + gap), y0, sc, sc, 0, c_white, 1);
    }
  };
  #endregion

  #region MÉTODOS DO PLAYER
  self.pl_attack_start = function() {
    is_attacking = true;
    attack_timer = 0;

    switch (facing) {
      case 0: attack_lock_x = 0; attack_lock_y = 1; break;
      case 3: attack_lock_x = 0; attack_lock_y = -1; break;
      case 1: attack_lock_x = -1; attack_lock_y = 0; break;
      case 2: attack_lock_x = 1; attack_lock_y = 0; break;
    }

    last_mx = attack_lock_x;
    last_my = attack_lock_y;

    var spr_atk = pl_sprite_attack(facing);
    sprite_index = spr_atk;
    image_xscale = (facing == 2) ? -1 : 1;
    image_speed  = 0;
    image_index  = 0;

    anim_timer = 0;
    anim_hold  = attack_hold_steps;

    attack_last = sprite_get_number(sprite_index) - 1;
    if (attack_last < 0) attack_last = 0;

    hsp = 0; vsp = 0;
    x_resto = 0; y_resto = 0;
  };

  self.pl_shoot_start = function() {
    is_shooting = true;
    shoot_timer = 0;

    switch (facing) {
      case 0: attack_lock_x = 0; attack_lock_y = 1; break;
      case 3: attack_lock_x = 0; attack_lock_y = -1; break;
      case 1: attack_lock_x = -1; attack_lock_y = 0; break;
      case 2: attack_lock_x = 1; attack_lock_y = 0; break;
    }

    last_mx = attack_lock_x;
    last_my = attack_lock_y;

    hsp = 0; vsp = 0;
    x_resto = 0; y_resto = 0;

    var spr_use = pl_sprite_attack(facing);
    sprite_index = spr_use;
    image_xscale = (facing == 2) ? -1 : 1;
    image_speed  = 0;
    image_index  = 0;

    anim_timer = 0;
    anim_hold  = shoot_hold_steps;

    shoot_anim_last = sprite_get_number(sprite_index) - 1;
    if (shoot_anim_last < 0) shoot_anim_last = 0;

    if (proj_obj != -1) {
      var cx = (bbox_left + bbox_right) * 0.5;
      var cy = (bbox_top + bbox_bottom) * 0.5;

      var sx = cx;
      var sy = cy;

      switch (facing) {
        case 0: // down
          sx = cx;
          sy = bbox_bottom + 1 + shoot_hand_y_ud;
          break;

        case 3: // up
          sx = cx;
          sy = bbox_top - 1 + shoot_hand_y_ud;
          break;

        case 1: // left
          sx = bbox_left - 1;
          sy = cy + shoot_hand_y_side;
          break;

        case 2: // right
          sx = bbox_right + 1;
          sy = cy + shoot_hand_y_side;
          break;
      }

      sx = round(sx);
      sy = round(sy);

      if (solid_obj == -1 || !place_meeting(sx, sy, solid_obj)) {
        var p = instance_create_layer(sx, sy, layer, proj_obj);
        p.dir = facing;
      } else {
        var p2 = instance_create_layer(x, y, layer, proj_obj);
        p2.dir = facing;
      }
    }

    shoot_cooldown = shoot_cooldown_max;
  };
  #endregion
}
