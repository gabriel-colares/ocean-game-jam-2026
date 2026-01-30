/// Create Event - obj_player

#region CONTROLES
key_left_primary  = ord("A");
key_left_alt      = vk_left;
key_right_primary = ord("D");
key_right_alt     = vk_right;
key_up_primary    = ord("W");
key_up_alt        = vk_up;
key_down_primary  = ord("S");
key_down_alt      = vk_down;

key_attack_primary = ord("J");
key_attack_alt     = ord("Z");

// TIRO (LANÇA)
key_shoot_primary  = ord("K");
key_shoot_alt      = vk_shift;
#endregion

#region GAMEPAD CONFIG (fallback 0..11)
pad_deadzone  = 0.25;   // 0.20~0.35 (ajuste fino)
pad_scan_max  = 11;     // 0..11 (igual teu debug)
pad_use_dpad  = true;
pad_use_stick = true;

// ações (compat geral: FACE 1/2/3/4)
pad_btn_attack = gp_face1; // X (PS) / A (Xbox)
pad_btn_shoot  = gp_face2; // O (PS) / B (Xbox)

// helper: pega o primeiro gamepad conectado (0..pad_scan_max)
function pl_gamepad_find_first() {
  for (var i = 0; i <= pad_scan_max; i++) {
    if (gamepad_is_connected(i)) return i;
  }
  return -1;
}

// helper: deadzone por eixo (com reescala)
function pl_apply_deadzone_axis(v, dz) {
  if (abs(v) < dz) return 0;
  var s = sign(v);
  return s * ((abs(v) - dz) / (1 - dz));
}
#endregion

#region ORIENTAÇÃO
// 0=down, 1=left, 2=right, 3=up
facing = 0;

axis_lock = 0;        // 0=none, 1=horizontal, 2=vertical
prev_wants_move = false;

prev_left  = false;
prev_right = false;
prev_up    = false;
prev_down  = false;
#endregion

#region MOVIMENTO
hsp = 0;
vsp = 0;

x_resto = 0;
y_resto = 0;

move_speed = 2.2;
accel_move = 0.95;
decel_stop = 1.10;
#endregion

#region COLISÃO
solid_obj = asset_get_index("obj_solid"); // -1 se não existir
#endregion

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

#region TIRO (LANÇA)
proj_obj = obj_spear_proj;

shoot_cooldown_max = 12;
shoot_cooldown     = 0;

// ajuste fino (16x16) para alinhar na mão
shoot_hand_y_side = 2; // left/right (aumente pra descer)
shoot_hand_y_ud   = 0; // up/down (se precisar)
#endregion

#region FUNÇÕES
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

self.pl_attack_start = function() {
  is_attacking = true;
  attack_timer = 0;

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
