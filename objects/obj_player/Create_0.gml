#region CONTROLES
key_left_primary  = vk_left;
key_left_alt      = ord("A");
key_right_primary = vk_right;
key_right_alt     = ord("D");
key_jump_primary  = vk_space;
key_jump_alt      = ord("Z");
#endregion

#region ORIENTAÇÃO
sprite_faces_left = true;
facing = 1;
#endregion

#region MOVIMENTO
hsp = 0;
vsp = 0;

x_resto = 0;
y_resto = 0;

move_speed   = 2.6;

accel_ground = 0.95;
accel_air    = 3.20;

decel_ground = 1.15;
decel_air    = 0.45;

grav     = 0.35;
max_fall = 10.5;

jump_speed = 6;
jump_cut   = 0.45;

coyote_frames = 6;
buffer_frames = 6;

coyote_timer = 0;
buffer_timer = 0;

on_ground = false;

solid_obj = obj_solid;
#endregion

#region ANIMAÇÃO
spr_idle = spr_player_idle;
spr_run  = spr_player_run;
spr_jump = spr_player_jump;
spr_fall = spr_player_fall;

sprite_index = spr_idle;
image_index  = 0;
image_speed  = 1;
#endregion
