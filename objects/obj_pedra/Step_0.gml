if (!variable_instance_exists(self, "pedra_inited")) {
  pedra_inited = true;
  pedra_fading = false;
  pedra_had_enemies = (instance_number(obj_enemy_base) > 0);
  image_alpha = 1;
  pedra_fade_spd = 0.03;
}

if (!pedra_had_enemies && instance_number(obj_enemy_base) > 0) {
  pedra_had_enemies = true;
}

if (!pedra_fading && pedra_had_enemies) {
  var any_alive = false;
  var n = instance_number(obj_enemy_base);
  for (var i = 0; i < n; i++) {
    var e = instance_find(obj_enemy_base, i);
    if (!instance_exists(e)) continue;

    var is_dead = false;
    if (variable_instance_exists(e, "dead")) is_dead = e.dead;
    else if (variable_instance_exists(e, "hp")) is_dead = (e.hp <= 0);

    if (!is_dead) { any_alive = true; break; }
  }

  if (!any_alive) pedra_fading = true;
}

if (pedra_fading) {
  image_alpha = max(0, image_alpha - pedra_fade_spd);
  if (image_alpha <= 0) instance_destroy();
}
