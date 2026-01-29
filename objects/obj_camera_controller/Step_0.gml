if (!instance_exists(target)) {
    target = instance_find(obj_player, 0);
    if (!instance_exists(target)) exit;
    base_y = target.y;
}

var b = instance_find(obj_camera_bounds, 0);
if (instance_exists(b)) {
    bound_l = b.bound_l;
    bound_t = b.bound_t;
    bound_r = b.bound_r;
    bound_b = b.bound_b;
}

var cx = camera_get_view_x(cam);
var cy = camera_get_view_y(cam);

var center_x = cx + view_w * 0.5;
var center_y = cy + view_h * 0.5;

var tx = target.x;
var ty = target.y;

var dx = tx - center_x;
if (abs(dx) > dead_w * 0.5) {
    center_x += (dx - sign(dx) * dead_w * 0.5);
}

base_y = lerp(base_y, ty, 0.05);

var dy = ty - center_y;
if (abs(dy) > dead_h * 0.5) {
    center_y += (dy - sign(dy) * dead_h * 0.5);
}

center_y = clamp(center_y, base_y - max_y_offset, base_y + max_y_offset);

var desired_x = center_x - view_w * 0.5;
var desired_y = center_y - view_h * 0.5;

cx = lerp(cx, desired_x, follow_lerp_x);
cy = lerp(cy, desired_y, follow_lerp_y);

cx = clamp(cx, bound_l, bound_r - view_w);
cy = clamp(cy, bound_t, bound_b - view_h);

cx = floor(cx);
cy = floor(cy);

camera_set_view_pos(cam, cx, cy);
