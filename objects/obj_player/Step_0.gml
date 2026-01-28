#region INPUT
var left_down  = keyboard_check(key_left_primary)  || keyboard_check(key_left_alt);
var right_down = keyboard_check(key_right_primary) || keyboard_check(key_right_alt);
var up_down    = keyboard_check(key_up_primary)    || keyboard_check(key_up_alt);
var down_down  = keyboard_check(key_down_primary)  || keyboard_check(key_down_alt);

var left_press  = left_down  && !prev_left;
var right_press = right_down && !prev_right;
var up_press    = up_down    && !prev_up;
var down_press  = down_down  && !prev_down;

prev_left  = left_down;
prev_right = right_down;
prev_up    = up_down;
prev_down  = down_down;

var ix = (right_down ? 1 : 0) - (left_down ? 1 : 0);
var iy = (down_down  ? 1 : 0) - (up_down   ? 1 : 0);
#endregion

#region DIREÇÃO (lock pela primeira tecla)
var left_press  = left_down  && !prev_left;
var right_press = right_down && !prev_right;
var up_press    = up_down    && !prev_up;
var down_press  = down_down  && !prev_down;

prev_left  = left_down;
prev_right = right_down;
prev_up    = up_down;
prev_down  = down_down;

var wants_h = (ix != 0);
var wants_v = (iy != 0);
var wants_move = wants_h || wants_v;

// Início do movimento: trava no eixo que começou
if (wants_move && !prev_wants_move) {
    if (right_press || left_press) axis_lock = 1;
    else if (down_press || up_press) axis_lock = 2;
    else axis_lock = wants_h ? 1 : 2;
}

// Mantém a direção do eixo travado enquanto ele existir
if (wants_move) {
    if (axis_lock == 1) {
        if (wants_h) {
            facing = (ix < 0) ? 1 : 2;
        } else {
            axis_lock = 2;
            facing = (iy < 0) ? 3 : 0;
        }
    } else { // axis_lock == 2 (ou 0)
        if (wants_v) {
            facing = (iy < 0) ? 3 : 0;
        } else {
            axis_lock = 1;
            facing = (ix < 0) ? 1 : 2;
        }
    }
} else {
    axis_lock = 0;
}

prev_wants_move = wants_move;
#endregion

#region EIXO DOMINANTE (ordem de pressionamento)
if (right_press || left_press) last_axis = 1;
if (down_press  || up_press)   last_axis = 2;

var has_h = (ix != 0);
var has_v = (iy != 0);

if (has_h && !has_v) last_axis = 1;
if (has_v && !has_h) last_axis = 2;

if (ix != 0 || iy != 0) {
    if (last_axis == 1) facing = (ix < 0) ? 1 : 2;
    else                facing = (iy < 0) ? 3 : 0;
}
#endregion

#region NORMALIZAÇÃO
var len = sqrt(ix*ix + iy*iy);
if (len > 0) { ix /= len; iy /= len; }
#endregion

#region MOVIMENTO
var target_hsp = ix * move_speed;
var target_vsp = iy * move_speed;

if (len > 0) {
    hsp = pl_approach(hsp, target_hsp, accel_move);
    vsp = pl_approach(vsp, target_vsp, accel_move);
} else {
    hsp = pl_approach(hsp, 0, decel_stop);
    vsp = pl_approach(vsp, 0, decel_stop);
}
#endregion

#region COLISÃO
x_resto += hsp;
y_resto += vsp;

var mx = round(x_resto);
var my = round(y_resto);

x_resto -= mx;
y_resto -= my;

var blocked = false;

if (solid_obj != -1) {
    var sx = sign(mx);
    repeat (abs(mx)) {
        if (!place_meeting(x + sx, y, solid_obj)) x += sx;
        else { hsp = 0; x_resto = 0; blocked = true; break; }
    }

    var sy = sign(my);
    repeat (abs(my)) {
        if (!place_meeting(x, y + sy, solid_obj)) y += sy;
        else { vsp = 0; y_resto = 0; blocked = true; break; }
    }
} else {
    x += mx;
    y += my;
}
#endregion

#region ANIMAÇÃO
image_xscale = (facing == 2) ? -1 : 1;

// “run” se o jogador está tentando se mover (input), mesmo travado na parede
var wants_move = (ix != 0) || (iy != 0);
var running = wants_move;

if (running) {
    idle_stop_timer = 0;

    var spr_run = pl_sprite_run(facing);
    pl_anim_set(spr_run, 0, run_hold_steps);

    var last_run = sprite_get_number(sprite_index) - 1;
    if (last_run < 0) last_run = 0;

    pl_anim_update_range(0, last_run);

} else {
    var spr_idle = pl_sprite_idle(facing);

    if (sprite_index != spr_idle) {
        pl_anim_set(spr_idle, 0, idle_hold_steps);
        idle_stop_timer = idle_stop_hold;
    }

    if (idle_stop_timer > 0) {
        idle_stop_timer--;
        image_speed = 0;
        image_index = 0;
        anim_timer  = 0;
    } else {
        var last_idle = sprite_get_number(sprite_index) - 1;

        if (last_idle <= 0) {
            image_speed = 0;
            image_index = 0;
        } else {
            if (floor(image_index) < 1) image_index = 1;

            anim_hold = idle_hold_steps;
            pl_anim_update_range(1, last_idle);
        }
    }
}
#endregion
