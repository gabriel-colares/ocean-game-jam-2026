draw_self();

if (saci_triggered || saci_do_fade) exit;
if (encounter_id != 1) exit;

if (!variable_global_exists("saci_stage")) global.saci_stage = 0;
if (global.saci_stage != 0) exit;

var cam = view_camera[0];
if (cam == noone) exit;

var vx = camera_get_view_x(cam);
var vy = camera_get_view_y(cam);
var vw = camera_get_view_width(cam);
var vh = camera_get_view_height(cam);

var on_screen = (bbox_right >= vx) && (bbox_left <= vx + vw) && (bbox_bottom >= vy) && (bbox_top <= vy + vh);
if (on_screen) saci_seen = true;
