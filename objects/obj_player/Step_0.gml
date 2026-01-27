#region FUNÇÕES
function _approach(_v, _t, _a) {
    if (_v < _t) return min(_v + _a, _t);
    return max(_v - _a, _t);
}

function _apply_sprite_speed_from_asset(_spr) {
    var fps_game = game_get_speed(gamespeed_fps);
    var spd_type = sprite_get_speed_type(_spr);
    var spd_val  = sprite_get_speed(_spr);

    if (spd_type == spritespeed_framespersecond) {
        image_speed = spd_val / fps_game;
    } else {
        image_speed = spd_val;
    }
}
#endregion

#region INPUT
var left_down  = keyboard_check(key_left_primary)  || keyboard_check(key_left_alt);
var right_down = keyboard_check(key_right_primary) || keyboard_check(key_right_alt);
var move = (right_down ? 1 : 0) - (left_down ? 1 : 0);

var jump_pressed  = keyboard_check_pressed(key_jump_primary)  || keyboard_check_pressed(key_jump_alt);
var jump_released = keyboard_check_released(key_jump_primary) || keyboard_check_released(key_jump_alt);
#endregion

#region CHÃO / COYOTE / BUFFER
on_ground = place_meeting(x, y + 1, solid_obj);

if (on_ground) coyote_timer = coyote_frames; else coyote_timer = max(0, coyote_timer - 1);
if (jump_pressed) buffer_timer = buffer_frames; else buffer_timer = max(0, buffer_timer - 1);
#endregion

#region HORIZONTAL
var target_hsp = move * move_speed;

if (move != 0) {
    hsp = _approach(hsp, target_hsp, on_ground ? accel_ground : accel_air);
} else {
    hsp = _approach(hsp, 0, on_ground ? decel_ground : decel_air);
}
#endregion

#region GRAVIDADE / PULO
vsp += grav;
if (vsp > max_fall) vsp = max_fall;

if (buffer_timer > 0 && coyote_timer > 0) {
    vsp = -jump_speed;
    buffer_timer = 0;
    coyote_timer = 0;
}

if (jump_released && vsp < 0) {
    vsp *= jump_cut;
}
#endregion

#region COLISÃO (subpixel)
x_resto += hsp;
y_resto += vsp;

// quantos pixels inteiros mover neste frame
var mx = round(x_resto);
var my = round(y_resto);

// remove a parte já convertida em pixels (mantém o resto fracionário)
x_resto -= mx;
y_resto -= my;

// move X com colisão (1px por vez)
var sx = sign(mx);
repeat (abs(mx)) {
    if (!place_meeting(x + sx, y, solid_obj)) x += sx;
    else { hsp = 0; x_resto = 0; break; }
}

// move Y com colisão (1px por vez)
var sy = sign(my);
repeat (abs(my)) {
    if (!place_meeting(x, y + sy, solid_obj)) y += sy;
    else { vsp = 0; y_resto = 0; break; }
}
#endregion


#region FACING / FLIP
if (abs(hsp) > 0.05) facing = sign(hsp);

if (sprite_faces_left) image_xscale = -facing;
else                   image_xscale =  facing;
#endregion

#region ANIMAÇÃO
var spr_target;

if (!on_ground) {
    spr_target = (vsp < 0) ? spr_jump : spr_fall;
} else {
    spr_target = (abs(hsp) > 0.2) ? spr_run : spr_idle;
}

if (sprite_index != spr_target) {
    sprite_index = spr_target;
    image_index  = 0;
    _apply_sprite_speed_from_asset(sprite_index);
}
#endregion
