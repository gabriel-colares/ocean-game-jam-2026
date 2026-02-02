life--;
if (life <= 0) { instance_destroy(); exit; }

bob_t++;
y = base_y + sin(bob_t * 0.08) * 2;

var p = instance_find(obj_player, 0);
if (!instance_exists(p)) exit;

if (point_distance(x, y, p.x, p.y) > collect_r) exit;

var gain = 1;
if (variable_instance_exists(self, "hp_gain")) gain = max(1, hp_gain);

if (!variable_global_exists("player_hp_max")) global.player_hp_max = 3;
if (variable_instance_exists(p, "hp_max")) {
  p.hp_max += gain;
  global.player_hp_max = p.hp_max;
} else {
  global.player_hp_max += gain;
}

if (variable_instance_exists(p, "hp")) {
  var new_max = global.player_hp_max;
  if (variable_instance_exists(p, "hp_max")) new_max = p.hp_max;
  p.hp = min(p.hp + gain, new_max);
  global.player_hp = p.hp;
}

if (!variable_global_exists("player_respawn_hp")) global.player_respawn_hp = 1;
global.player_respawn_hp = max(global.player_respawn_hp, global.player_hp_max);

instance_destroy();
