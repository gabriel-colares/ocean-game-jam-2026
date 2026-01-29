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

attack_hold_steps = 3;
is_attacking = false;
attack_last  = 0;

sprite_index = sprIdleSide;
image_index  = 0;
image_speed  = 0;
image_xscale = 1;
mask_index = sprPlayerRunDown;

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

function pl_sprite_attack(_f) {
    if (_f == 0) return sprAtkDown;
    if (_f == 3) return sprAtkUp;
    return sprAtkSide;
}


function pl_attack_start() {
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
}
#endregion
