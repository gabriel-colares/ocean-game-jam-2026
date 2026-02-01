function en_group_ensure() {
  if (!variable_global_exists("en_slots")) global.en_slots = ds_map_create();
}

function en_group_slot_key(_target, _slot) {
  return string(_target) + ":" + string(_slot);
}

function en_group_slot_pos(_tx, _ty, _slot, _radius) {
  var a = _slot * (360 / 8);
  return { x: _tx + lengthdir_x(_radius, a), y: _ty + lengthdir_y(_radius, a) };
}

function en_group_release_slot(_target, _slot, _owner) {
  if (!variable_global_exists("en_slots")) return;
  var key = en_group_slot_key(_target, _slot);
  if (!ds_map_exists(global.en_slots, key)) return;
  var claim = ds_map_find_value(global.en_slots, key);
  if (is_struct(claim) && claim.owner == _owner) ds_map_delete(global.en_slots, key);
}

function en_group_pick_slot(_me, _target) {
  en_group_ensure();
  if (!instance_exists(_target)) return -1;

  var tx = _target.x;
  var ty = _target.y;
  var best_slot = -1;
  var best_d2 = 1000000000000;

  for (var s = 0; s < 8; s++) {
    var key = en_group_slot_key(_target, s);
    if (ds_map_exists(global.en_slots, key)) {
      var claim = ds_map_find_value(global.en_slots, key);
      var stale = true;
      if (is_struct(claim)) {
        if (instance_exists(claim.owner)) {
          stale = ((current_time - claim.t) > _me.cfg.slot_hold_ms);
        }
      }
      if (stale) ds_map_delete(global.en_slots, key);
    }

    if (!ds_map_exists(global.en_slots, key)) {
      var p = en_group_slot_pos(tx, ty, s, _me.cfg.slot_radius);
      var dx = p.x - _me.x;
      var dy = p.y - _me.y;
      var d2 = dx * dx + dy * dy;
      if (d2 < best_d2) {
        best_d2 = d2;
        best_slot = s;
      }
    }
  }

  if (best_slot != -1) {
    var k2 = en_group_slot_key(_target, best_slot);
    ds_map_set(global.en_slots, k2, { owner: _me.id, t: current_time });
  }

  return best_slot;
}

function en_group_refresh_slot(_me) {
  if (_me.slot_id < 0) return;
  en_group_ensure();
  if (!instance_exists(_me.target_id)) { _me.slot_id = -1; return; }
  var key = en_group_slot_key(_me.target_id, _me.slot_id);
  if (ds_map_exists(global.en_slots, key)) {
    var claim = ds_map_find_value(global.en_slots, key);
    if (is_struct(claim) && claim.owner == _me.id) {
      claim.t = current_time;
      ds_map_set(global.en_slots, key, claim);
    }
  }
}

function en_group_attackers_near(_target, _radius) {
  var count = 0;
  with (obj_enemy_base) {
    if (!dead && instance_exists(target_id) && target_id == _target) {
      var dx = x - _target.x;
      var dy = y - _target.y;
      if ((dx * dx + dy * dy) <= (_radius * _radius)) {
        if (state == EN_STATE.ATTACK_WINDUP || state == EN_STATE.ATTACK_ACTIVE || state == EN_STATE.ATTACK_RECOVERY) {
          count++;
        } else if (wants_attack) {
          count++;
        }
      }
    }
  }
  return count;
}

function en_group_can_attack(_me, _target) {
  if (!instance_exists(_target)) return false;
  if (_me.state == EN_STATE.ATTACK_WINDUP || _me.state == EN_STATE.ATTACK_ACTIVE || _me.state == EN_STATE.ATTACK_RECOVERY) return true;
  var attackers = en_group_attackers_near(_target, _me.cfg.attack_range + 10);
  return (attackers < _me.cfg.max_attackers);
}
