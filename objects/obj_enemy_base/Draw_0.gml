draw_self();

if (variable_instance_exists(self, "hpbar_show_t") && hpbar_show_t > 0 && variable_instance_exists(self, "hp") && variable_instance_exists(self, "hp_max") && hp_max > 0) {
  var bar_w = 26;
  var bar_h = 4;
  var bar_x1 = ((bbox_left + bbox_right) * 0.5) - (bar_w * 0.5);
  var bar_y1 = bbox_top - 6;
  var pct = clamp(hp / hp_max, 0, 1);

  draw_set_alpha(0.75);
  draw_set_color(c_black);
  draw_rectangle(bar_x1 - 1, bar_y1 - 1, bar_x1 + bar_w + 1, bar_y1 + bar_h + 1, false);

  draw_set_alpha(0.95);
  draw_set_color(make_color_rgb(70, 10, 10));
  draw_rectangle(bar_x1, bar_y1, bar_x1 + bar_w, bar_y1 + bar_h, false);

  draw_set_color(make_color_rgb(60, 220, 80));
  draw_rectangle(bar_x1, bar_y1, bar_x1 + bar_w * pct, bar_y1 + bar_h, false);

  draw_set_alpha(1);
}

var dbg = false;
if (variable_global_exists("en_debug")) dbg = global.en_debug;
if (!dbg) return;

draw_set_alpha(1);
draw_set_color(c_white);
draw_text(x + 10, y - 26, en_state_name(state));
draw_text(x + 10, y - 14, "los:" + string(has_los) + " cd:" + string(atk_cd) + " slot:" + string(slot_id));

draw_set_alpha(0.15);
draw_set_color(c_yellow);
draw_circle(x, y, cfg.agro_radius, false);

draw_set_color(c_aqua);
draw_circle(x, y, cfg.sep_radius, false);

if (instance_exists(target_id)) {
  draw_set_alpha(0.75);
  draw_set_color(has_los ? c_lime : c_red);
  draw_line(x, y, target_id.x, target_id.y);
}

draw_set_alpha(0.9);
draw_set_color(c_fuchsia);
draw_circle(target_x, target_y, 2, false);

draw_set_color(c_gray);
draw_circle(last_seen_x, last_seen_y, 2, false);
