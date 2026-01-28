#region CONTROLES
key_left_primary  = vk_left;
key_left_alt      = ord("A");
key_right_primary = vk_right;
key_right_alt     = ord("D");
key_up_primary    = vk_up;
key_up_alt        = ord("W");
key_down_primary  = vk_down;
key_down_alt      = ord("S");
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

sprite_index = sprIdleSide;
image_index  = 0;
image_speed  = 0;
image_xscale = 1;

run_hold_steps  = 4;
idle_hold_steps = 12;
idle_stop_hold  = 10;

anim_hold       = run_hold_steps;
anim_timer      = 0;
idle_stop_timer = 0;
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
#endregion
