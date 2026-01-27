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

#region MOVIMENTO
hsp = 0;
vsp = 0;

x_resto = 0;
y_resto = 0;

move_speed = 2;
accel_move = 0.95;
decel_stop = 1.15;

solid_obj = obj_solid;
#endregion

#region ORIENTAÇÃO
// sprite padrão = esquerda
facing = 1; // 1=left, 2=right, 3=up, 0=down
#endregion

#region ANIMAÇÃO
spr_idle = spr_player_idle;
spr_run  = spr_player_run;

sprite_index = spr_idle;
image_index  = 0;
image_speed  = 1;
image_xscale = 1;
#endregion

#region FUNÇÕES
function _approach(_v, _t, _a) {
    if (_v < _t) return min(_v + _a, _t);
    return max(_v - _a, _t);
}

function _apply_sprite_speed_from_asset(_spr) {
    var fps_game = game_get_speed(gamespeed_fps);
    var spd_type = sprite_get_speed_type(_spr);
    var spd_val  = sprite_get_speed(_spr);

    if (spd_type == spritespeed_framespersecond) image_speed = spd_val / fps_game;
    else image_speed = spd_val;
}
#endregion
