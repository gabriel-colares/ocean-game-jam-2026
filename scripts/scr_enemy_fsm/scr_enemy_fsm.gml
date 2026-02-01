function en_set_state(_st) {
  if (state == _st) return;

  if (state == EN_STATE.REPOSITION && slot_id >= 0 && instance_exists(target_id)) {
    en_group_release_slot(target_id, slot_id, id);
    slot_id = -1;
  }

  state = _st;
  state_t = 0;

  if (_st == EN_STATE.ATTACK_WINDUP) {
    atk_facing = facing;
  }

  if (_st == EN_STATE.DEAD) {
    dead = true;
    hsp = 0;
    vsp = 0;
    if (slot_id >= 0 && instance_exists(target_id)) {
      en_group_release_slot(target_id, slot_id, id);
      slot_id = -1;
    }
  }
}

function en_fsm() {
  if (dead) { en_set_state(EN_STATE.DEAD); return; }

  state_t++;

  if (atk_cd > 0) atk_cd--;
  if (hitstun_t > 0) hitstun_t--;

  if (!instance_exists(target_id)) target_id = instance_find(obj_player, 0);

  var tx = x;
  var ty = y;
  if (instance_exists(target_id)) { tx = target_id.x; ty = target_id.y; }

  var dx = tx - x;
  var dy = ty - y;
  var dist = sqrt(dx * dx + dy * dy);

  var seen_recently = (last_seen_t <= cfg.lose_sight_time);
  var can_chase = in_agro && (has_los || seen_recently);

  wants_attack = false;
  if (instance_exists(target_id)) wants_attack = en_group_can_attack(self, target_id);

  if (state == EN_STATE.IDLE || state == EN_STATE.PATROL) {
    if (can_chase) en_set_state(EN_STATE.ALERT);
    return;
  }

  if (state == EN_STATE.ALERT) {
    if (!can_chase) { en_set_state(EN_STATE.PATROL); return; }
    if (state_t >= cfg.react_time) en_set_state(EN_STATE.CHASE);
    return;
  }

  if (state == EN_STATE.HITSTUN) {
    if (hitstun_t <= 0) {
      if (can_chase) {
        if (dist <= cfg.attack_range && atk_cd <= 0 && wants_attack) en_set_state(EN_STATE.ATTACK_WINDUP);
        else if (!wants_attack || dist < cfg.attack_range * 0.9) en_set_state(EN_STATE.REPOSITION);
        else en_set_state(EN_STATE.CHASE);
      } else {
        en_set_state(EN_STATE.PATROL);
      }
    }
    return;
  }

  if (state == EN_STATE.CHASE) {
    if (!can_chase) { en_set_state(EN_STATE.PATROL); return; }

    if (dist <= cfg.attack_range && atk_cd <= 0 && wants_attack) {
      en_set_state(EN_STATE.ATTACK_WINDUP);
      return;
    }

    if (!wants_attack || dist < cfg.attack_range * 0.9) {
      en_set_state(EN_STATE.REPOSITION);
      return;
    }

    return;
  }

  if (state == EN_STATE.REPOSITION) {
    if (!can_chase) { en_set_state(EN_STATE.PATROL); return; }

    if (dist <= cfg.attack_range && atk_cd <= 0 && wants_attack) {
      en_set_state(EN_STATE.ATTACK_WINDUP);
      return;
    }

    if (wants_attack && dist > cfg.attack_range * 1.35) {
      en_set_state(EN_STATE.CHASE);
      return;
    }

    return;
  }

  if (state == EN_STATE.ATTACK_WINDUP) {
    facing = atk_facing;
    if (!can_chase) { en_set_state(EN_STATE.PATROL); return; }
    if (dist > cfg.attack_range + 10) { en_set_state(EN_STATE.CHASE); return; }
    if (state_t >= cfg.attack_windup) en_set_state(EN_STATE.ATTACK_ACTIVE);
    return;
  }

  if (state == EN_STATE.ATTACK_ACTIVE) {
    facing = atk_facing;
    if (state_t == 1) cfg.do_attack(self);
    if (state_t >= cfg.attack_active) en_set_state(EN_STATE.ATTACK_RECOVERY);
    return;
  }

  if (state == EN_STATE.ATTACK_RECOVERY) {
    facing = atk_facing;
    if (state_t >= cfg.attack_recovery) {
      atk_cd = cfg.attack_cooldown;
      if (can_chase) {
        if (!wants_attack || dist < cfg.attack_range * 0.9) en_set_state(EN_STATE.REPOSITION);
        else en_set_state(EN_STATE.CHASE);
      } else {
        en_set_state(EN_STATE.PATROL);
      }
    }
    return;
  }
}
