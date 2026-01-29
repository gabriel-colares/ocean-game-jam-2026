view_w = 21 * 16;
view_h = 12 * 16;

follow_lerp_x = 0.16;
follow_lerp_y = 0.10;

dead_w = view_w * 0.05;
dead_h = view_h * 0.08;

max_y_offset = 32;

target = noone;

view_enabled = true;
view_visible[0] = true;

cam = camera_create_view(0, 0, view_w, view_h, 0, noone, 0, 0, 0, 0);
view_camera[0] = cam;

bound_l = 0;
bound_t = 0;
bound_r = room_width;
bound_b = room_height;

base_y = room_height * 0.5;
