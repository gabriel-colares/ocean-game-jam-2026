if (saci_do_fade) {
  image_alpha = max(0, image_alpha - saci_fade_dalpha);
  if (image_alpha <= 0) instance_destroy();
  exit;
}

if (saci_triggered) exit;

if (!instance_exists(obj_player)) exit;

if (!variable_global_exists("saci_stage")) global.saci_stage = 0;

var should_start = false;
var p = instance_find(obj_player, 0);
if (!instance_exists(p)) exit;
var dist = point_distance(x, y, p.x, p.y);
if (encounter_id == 1) {
  should_start = (global.saci_stage == 0) && (dist <= near_dist);
} else if (encounter_id == 2) {
  should_start = (global.saci_stage == 1) && (dist <= near_dist);
}

if (!should_start) exit;

var cc = instance_find(obj_camera_controller, 0);
if (!instance_exists(cc)) exit;

if (cc.saci_dialog_active || cc.dead_dialog_active || cc.intro_active || cc.intro_fade_out) exit;

var lines = [];
if (encounter_id == 1) {
  lines = [
    "Anahi:\n...Tem alguem ai?",
    "Saci:\nHehehe... cuidado, menina. Nem tudo que responde quer ser encontrado."
  ];
} else if (encounter_id == 2) {
  lines = cc.saci_dialog_lines2;
}

if (array_length_1d(lines) <= 0) exit;

cc.saci_dialog_lines = lines;
cc.saci_dialog_index = 0;
cc.saci_dialog_text = cc.saci_dialog_lines[0];
cc.saci_dialog_owner = id;
cc.saci_dialog_active = true;

saci_triggered = true;
