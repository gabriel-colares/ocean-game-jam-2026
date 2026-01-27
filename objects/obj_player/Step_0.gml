#region INPUT
var left_down  = keyboard_check(key_left_primary)  || keyboard_check(key_left_alt);
var right_down = keyboard_check(key_right_primary) || keyboard_check(key_right_alt);
var up_down    = keyboard_check(key_up_primary)    || keyboard_check(key_up_alt);
var down_down  = keyboard_check(key_down_primary)  || keyboard_check(key_down_alt);

var ix = (right_down ? 1 : 0) - (left_down ? 1 : 0);
var iy = (down_down  ? 1 : 0) - (up_down   ? 1 : 0);
#endregion

#region MOVIMENTO
var len = sqrt(ix*ix + iy*iy);
if (len > 0) { ix /= len; iy /= len; }

var target_hsp = ix * move_speed;
var target_vsp = iy * move_speed;

if (len > 0) {
    hsp = _approach(hsp, target_hsp, accel_move);
    vsp = _approach(vsp, target_vsp, accel_move);
} else {
    hsp = _approach(hsp, 0, decel_stop);
    vsp = _approach(vsp, 0, decel_stop);
}
#endregion

#region COLISÃO
x_resto += hsp;
y_resto += vsp;

var mx = round(x_resto);
var my = round(y_resto);

x_resto -= mx;
y_resto -= my;

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
#endregion

#region FACING + FLIP
if (len > 0) {
    if (abs(ix) > abs(iy)) facing = (ix < 0) ? 1 : 2;
    else                   facing = (iy < 0) ? 3 : 0;
}

if (facing == 2) image_xscale = -1; // right
else if (facing == 1) image_xscale = 1; // left
#endregion

#region ANIMAÇÃO
var moving = (abs(hsp) + abs(vsp)) > 0.15;
var spr_target = moving ? spr_run : spr_idle;

if (sprite_index != spr_target) {
    sprite_index = spr_target;
    image_index  = 0;
    _apply_sprite_speed_from_asset(sprite_index);
}
#endregion
