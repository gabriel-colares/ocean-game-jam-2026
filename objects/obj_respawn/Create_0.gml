global.respawn_room = room;
global.respawn_x = x;
global.respawn_y = y;

global.respawn_apply = true;
global.respawn_restarting = false;

respawn_delay_steps = max(1, ceil(room_speed * 1.0));
respawn_t = 0;
