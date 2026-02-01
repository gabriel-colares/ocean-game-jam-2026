function en_approach(_cur, _target, _step) {
  if (_cur < _target) return min(_cur + _step, _target);
  if (_cur > _target) return max(_cur - _step, _target);
  return _cur;
}

function en_facing_from_vector(_dx, _dy) {
  if (abs(_dx) >= abs(_dy)) return (_dx < 0) ? 1 : 2;
  return (_dy < 0) ? 3 : 0;
}

function en_facing_to_dir(_f) {
  if (_f == 0) return 90;
  if (_f == 3) return 270;
  if (_f == 1) return 180;
  return 0;
}

function en_move_target_point() {
  if (!instance_exists(target_id)) return { x: x, y: y };

  if (state == EN_STATE.REPOSITION) {
    if (slot_id < 0) slot_id = en_group_pick_slot(self, target_id);
    en_group_refresh_slot(self);

    if (slot_id >= 0) {
      var p = en_group_slot_pos(target_id.x, target_id.y, slot_id, cfg.slot_radius);
      slot_x = p.x;
      slot_y = p.y;
      return p;
    }

    var a = (id * 23 + (current_time * 0.06)) mod 360;
    return { x: target_id.x + lengthdir_x(cfg.slot_radius, a), y: target_id.y + lengthdir_y(cfg.slot_radius, a) };
  }

  if (has_los || last_seen_t <= cfg.lose_sight_time) {
    var keep = 0;
    var dx = x - target_id.x;
    var dy = y - target_id.y;
    var d = sqrt(dx * dx + dy * dy);
    if (d > 0) {
      dx /= d;
      dy /= d;
      return { x: target_id.x + dx * keep, y: target_id.y + dy * keep };
    }
    return { x: target_id.x, y: target_id.y };
  }

  return { x: last_seen_x, y: last_seen_y };
}

function en_move_detour_point(_tx, _ty) {
  if (solid_obj == -1) return { x: _tx, y: _ty };
  if (!collision_line(x, y, _tx, _ty, solid_obj, true, true)) return { x: _tx, y: _ty };

  var dir = point_direction(x, y, _tx, _ty);

  for (var i = 0; i < 4; i++) {
    var d = 24 + i * 16;

    var cx1 = x + lengthdir_x(d, dir + 90);
    var cy1 = y + lengthdir_y(d, dir + 90);
    if (!place_meeting(cx1, cy1, solid_obj) && !collision_line(x, y, cx1, cy1, solid_obj, true, true)) {
      return { x: cx1, y: cy1 };
    }

    var cx2 = x + lengthdir_x(d, dir - 90);
    var cy2 = y + lengthdir_y(d, dir - 90);
    if (!place_meeting(cx2, cy2, solid_obj) && !collision_line(x, y, cx2, cy2, solid_obj, true, true)) {
      return { x: cx2, y: cy2 };
    }
  }

  return { x: _tx, y: _ty };
}

function en_move_separation() {
  var rx = 0;
  var ry = 0;
  var r = cfg.sep_radius;
  var r2 = r * r;

  var lst = ds_list_create();
  var n = collision_circle_list(x, y, r, obj_enemy_base, false, true, lst, false);
  for (var i = 0; i < n; i++) {
    var e = lst[| i];
    if (e != id && instance_exists(e) && !e.dead) {
      var dx = x - e.x;
      var dy = y - e.y;
      var d2 = dx * dx + dy * dy;
      if (d2 > 0 && d2 < r2) {
        var d = sqrt(d2);
        var nx = dx / d;
        var ny = dy / d;
        var push = (1 - (d / r)) * cfg.sep_force;
        rx += nx * push;
        ry += ny * push;
      }
    }
  }
  ds_list_destroy(lst);

  return { x: rx, y: ry };
}

function en_move() {
  if (dead) { hsp = 0; vsp = 0; return; }

  if (state == EN_STATE.ATTACK_WINDUP || state == EN_STATE.ATTACK_ACTIVE || state == EN_STATE.ATTACK_RECOVERY) {
    hsp = en_approach(hsp, 0, cfg.decel_stop);
    vsp = en_approach(vsp, 0, cfg.decel_stop);
    en_move_apply_collision();
    return;
  }

  if (state == EN_STATE.HITSTUN) {
    hsp = en_approach(hsp, 0, cfg.decel_stop);
    vsp = en_approach(vsp, 0, cfg.decel_stop);
    en_move_apply_collision();
    return;
  }

  var tp = en_move_target_point();
  var dp = en_move_detour_point(tp.x, tp.y);
  target_x = dp.x;
  target_y = dp.y;

  var dx = target_x - x;
  var dy = target_y - y;
  var dist = sqrt(dx * dx + dy * dy);

  var want = (state == EN_STATE.CHASE || state == EN_STATE.REPOSITION);
  var des_h = 0;
  var des_v = 0;

  if (want && dist > 0.001) {
    var nx = dx / dist;
    var ny = dy / dist;
    var spd = cfg.move_speed;
    var arrive_r = 8;
    if (dist < arrive_r) spd *= (dist / arrive_r);
    des_h = nx * spd;
    des_v = ny * spd;
  }

  var sep = en_move_separation();
  des_h += sep.x;
  des_v += sep.y;

  hsp = en_approach(hsp, des_h, cfg.accel_move);
  vsp = en_approach(vsp, des_v, cfg.accel_move);

  if (abs(hsp) < 0.001) hsp = 0;
  if (abs(vsp) < 0.001) vsp = 0;

  if (hsp != 0 || vsp != 0) {
    if (!(state == EN_STATE.ATTACK_WINDUP || state == EN_STATE.ATTACK_ACTIVE || state == EN_STATE.ATTACK_RECOVERY)) {
      facing = en_facing_from_vector(hsp, vsp);
    }
  }

  en_move_apply_collision();
}

function en_move_apply_collision() {
  x_rem += hsp;
  y_rem += vsp;

  var mx = round(x_rem);
  var my = round(y_rem);

  x_rem -= mx;
  y_rem -= my;

  if (solid_obj != -1) {
    var sx = sign(mx);
    repeat (abs(mx)) {
      if (!place_meeting(x + sx, y, solid_obj)) x += sx;
      else { hsp = 0; x_rem = 0; break; }
    }

    var sy = sign(my);
    repeat (abs(my)) {
      if (!place_meeting(x, y + sy, solid_obj)) y += sy;
      else { vsp = 0; y_rem = 0; break; }
    }
  } else {
    x += mx;
    y += my;
  }

  var p = instance_find(obj_player, 0);
  if (instance_exists(p)) {
    var min_d = 14;
    var dx = x - p.x;
    var dy = y - p.y;
    var d2 = dx * dx + dy * dy;
    if (d2 < (min_d * min_d)) {
      if (d2 <= 0.001) { dx = 1; dy = 0; d2 = 1; }
      var d = sqrt(d2);
      var overlap = min_d - d;
      var nx = dx / d;
      var ny = dy / d;
      var px = round(nx * overlap);
      var py = round(ny * overlap);

      if (solid_obj != -1) {
        var sx2 = sign(px);
        repeat (abs(px)) {
          if (!place_meeting(x + sx2, y, solid_obj)) x += sx2;
          else break;
        }

        var sy2 = sign(py);
        repeat (abs(py)) {
          if (!place_meeting(x, y + sy2, solid_obj)) y += sy2;
          else break;
        }
      } else {
        x += px;
        y += py;
      }
    }
  }
}
