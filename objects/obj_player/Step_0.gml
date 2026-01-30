/// Step Event - obj_player (teclado + gamepad fallback 0..11, dpad + analógico)

#region INPUT
// --- teclado ---
var k_left  = keyboard_check(key_left_primary)  || keyboard_check(key_left_alt);
var k_right = keyboard_check(key_right_primary) || keyboard_check(key_right_alt);
var k_up    = keyboard_check(key_up_primary)    || keyboard_check(key_up_alt);
var k_down  = keyboard_check(key_down_primary)  || keyboard_check(key_down_alt);

var atk_press   = keyboard_check_pressed(key_attack_primary) || keyboard_check_pressed(key_attack_alt);
var shoot_press = keyboard_check_pressed(key_shoot_primary)  || keyboard_check_pressed(key_shoot_alt);

// --- gamepad (não quebra se não tiver controle) ---
var _gp = pl_gamepad_find_first();
var gp_ok = (_gp != -1);

var gp_dleft = false, gp_dright = false, gp_dup = false, gp_ddown = false;
var gp_lx = 0, gp_ly = 0;

if (gp_ok) {
  // dpad
  if (pad_use_dpad) {
    gp_dup    = gamepad_button_check(_gp, gp_padu);
    gp_ddown  = gamepad_button_check(_gp, gp_padd);
    gp_dleft  = gamepad_button_check(_gp, gp_padl);
    gp_dright = gamepad_button_check(_gp, gp_padr);
  }

  // analógico esquerdo
  if (pad_use_stick) {
    gp_lx = pl_apply_deadzone_axis(gamepad_axis_value(_gp, gp_axislh), pad_deadzone);
    gp_ly = pl_apply_deadzone_axis(gamepad_axis_value(_gp, gp_axislv), pad_deadzone);
  }

  // ações no controle
  atk_press   = atk_press   || gamepad_button_check_pressed(_gp, pad_btn_attack);
  shoot_press = shoot_press || gamepad_button_check_pressed(_gp, pad_btn_shoot);
}

// --- direção final (booleans) ---
var left_down  = k_left  || gp_dleft  || (gp_lx < 0);
var right_down = k_right || gp_dright || (gp_lx > 0);
var up_down    = k_up    || gp_dup    || (gp_ly < 0);
var down_down  = k_down  || gp_ddown  || (gp_ly > 0);

// --- vetor de movimento (float) ---
// prioridade: teclado > dpad > analógico
var ix = 0;
var iy = 0;

// X
if (k_left || k_right) ix = (k_right ? 1 : 0) - (k_left ? 1 : 0);
else if (gp_dleft || gp_dright) ix = (gp_dright ? 1 : 0) - (gp_dleft ? 1 : 0);
else ix = gp_lx;

// Y
if (k_up || k_down) iy = (k_down ? 1 : 0) - (k_up ? 1 : 0);
else if (gp_dup || gp_ddown) iy = (gp_ddown ? 1 : 0) - (gp_dup ? 1 : 0);
else iy = gp_ly;

var wants_h = (ix != 0);
var wants_v = (iy != 0);
var wants_move = wants_h || wants_v;
#endregion

#region DIREÇÃO (lock pela primeira tecla)
if (!is_attacking && !is_shooting) {
  var left_press  = left_down  && !prev_left;
  var right_press = right_down && !prev_right;
  var up_press    = up_down    && !prev_up;
  var down_press  = down_down  && !prev_down;

  prev_left  = left_down;
  prev_right = right_down;
  prev_up    = up_down;
  prev_down  = down_down;

  if (wants_move && !prev_wants_move) {
    if (right_press || left_press) axis_lock = 1;
    else if (down_press || up_press) axis_lock = 2;
    else axis_lock = wants_h ? 1 : 2;
  }

  if (wants_move) {
    if (axis_lock == 1) {
      if (wants_h) facing = (ix < 0) ? 1 : 2;
      else { axis_lock = 2; facing = (iy < 0) ? 3 : 0; }
    } else {
      if (wants_v) facing = (iy < 0) ? 3 : 0;
      else { axis_lock = 1; facing = (ix < 0) ? 1 : 2; }
    }
  } else axis_lock = 0;

  prev_wants_move = wants_move;
}
#endregion

#region COOLDOWN
if (shoot_cooldown > 0) shoot_cooldown--;
#endregion

#region ACTION START
if (!is_attacking && !is_shooting) {
  if (shoot_press && shoot_cooldown <= 0) {
    self.pl_shoot_start();
    shoot_timer = 0;
  } else if (atk_press) {
    self.pl_attack_start();
    attack_timer = 0;
  }
}
#endregion

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

} else if (wants_move) {
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

#region MOVIMENTO
if (!is_attacking && !is_shooting) {
  var mag = sqrt(ix*ix + iy*iy);

  if (mag > 0) {
    // teclado/dpad diagonal: mag > 1 -> normaliza (mantém mesma velocidade em qualquer direção)
    // analógico: mag <= 1 -> mantém intensidade (velocidade proporcional ao quanto inclinou)
    var scale = (mag > 1) ? (1 / mag) : 1;

    var target_hsp = (ix * scale) * (move_speed * min(mag, 1));
    var target_vsp = (iy * scale) * (move_speed * min(mag, 1));

    hsp = pl_approach(hsp, target_hsp, accel_move);
    vsp = pl_approach(vsp, target_vsp, accel_move);
  } else {
    hsp = pl_approach(hsp, 0, decel_stop);
    vsp = pl_approach(vsp, 0, decel_stop);
  }
} else {
  hsp = 0;
  vsp = 0;
}
#endregion

#region COLISÃO
x_resto += hsp;
y_resto += vsp;

var mx = round(x_resto);
var my = round(y_resto);

x_resto -= mx;
y_resto -= my;

if (solid_obj != -1) {
  var sx = sign(mx);
  repeat (abs(mx)) {
    if (!place_meeting(x + sx, y, solid_obj)) x += sx;
    else { hsp = 0; x_resto = 0; break; }
  }

  var sy = sign(my);
  repeat (abs(my)) {
    if (!place_meeting(x, y + sy, solid_obj)) y += sy;
    else { vsp = 0; y_resto = 0; break; }
  }
} else {
  x += mx;
  y += my;
}
#endregion
