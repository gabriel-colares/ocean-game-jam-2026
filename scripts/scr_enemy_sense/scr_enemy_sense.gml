function en_sense() {
  if (!instance_exists(target_id)) {
    target_id = instance_find(obj_player, 0);
    if (!instance_exists(target_id)) return;
  }

  var tx = target_id.x;
  var ty = target_id.y;

  var dx = tx - x;
  var dy = ty - y;
  var dist = sqrt(dx * dx + dy * dy);

  in_agro = (dist <= cfg.agro_radius);

  if (!variable_instance_exists(self, "los_t")) los_t = irandom(cfg.los_interval);
  los_t++;

  var check_los = (los_t >= cfg.los_interval);
  if (check_los) los_t = 0;

  if (check_los) {
    var ok = true;
    if (cfg.fov < 360) {
      var aim = point_direction(x, y, tx, ty);
      var fdir = en_facing_to_dir(facing);
      ok = (angle_difference(fdir, aim) <= (cfg.fov * 0.5));
    }

    if (ok) {
      has_los = !collision_line(x, y, tx, ty, obj_solid, true, true);
    } else {
      has_los = false;
    }
  }

  if (has_los) {
    last_seen_x = tx;
    last_seen_y = ty;
    last_seen_t = 0;
  } else {
    last_seen_t++;
  }
}
