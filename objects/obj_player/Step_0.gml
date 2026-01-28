#region INPUT
var left_down  = keyboard_check(key_left_primary)  || keyboard_check(key_left_alt);
var right_down = keyboard_check(key_right_primary) || keyboard_check(key_right_alt);
var up_down    = keyboard_check(key_up_primary)    || keyboard_check(key_up_alt);
var down_down  = keyboard_check(key_down_primary)  || keyboard_check(key_down_alt);

var atk_press = keyboard_check_pressed(key_attack_primary) || keyboard_check_pressed(key_attack_alt);

var ix = (right_down ? 1 : 0) - (left_down ? 1 : 0);
var iy = (down_down  ? 1 : 0) - (up_down   ? 1 : 0);

var wants_h = (ix != 0);
var wants_v = (iy != 0);
var wants_move = wants_h || wants_v;
#endregion

#region DIREÇÃO (lock pela primeira tecla)
if (!is_attacking) {
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

#region ATTACK START
if (!is_attacking && atk_press) {
    pl_attack_start();
}
#endregion

#region MOVIMENTO
if (!is_attacking) {
    var len = sqrt(ix*ix + iy*iy);
    if (len > 0) { ix /= len; iy /= len; }

    var target_hsp = ix * move_speed;
    var target_vsp = iy * move_speed;

    if (len > 0) {
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

#region ANIMAÇÃO
image_xscale = (facing == 2) ? -1 : 1;

if (is_attacking) {
    anim_hold = attack_hold_steps;

    var last = attack_last;
    if (last < 0) last = 0;

    pl_anim_update_range(0, last);

    // encerra quando completar o ciclo (voltou pro 0 após o last)
    if (floor(image_index) == 0 && anim_timer == 0 && last > 0) {
        is_attacking = false;
        idle_stop_timer = idle_stop_hold;
    }
} else {
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
}
#endregion
