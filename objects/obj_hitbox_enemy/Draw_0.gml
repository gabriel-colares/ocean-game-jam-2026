var dbg = false;
if (variable_global_exists("en_debug")) dbg = global.en_debug;
if (!dbg) return;

draw_set_alpha(0.35);
draw_set_color(c_red);

var x1 = x - (w * 0.5);
var y1 = y - (h * 0.5);
var x2 = x + (w * 0.5);
var y2 = y + (h * 0.5);
draw_rectangle(x1, y1, x2, y2, false);
