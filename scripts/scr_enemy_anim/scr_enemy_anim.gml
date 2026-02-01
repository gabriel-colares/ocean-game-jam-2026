function en_spr_pick_dir(_dir3, _f) {
  if (_f == 0) return _dir3.down;
  if (_f == 3) return _dir3.up;
  return _dir3.left;
}

function en_apply_sprite(_spr, _hold_steps, _flip_x) {
  if (sprite_index != _spr) {
    sprite_index = _spr;
    image_index = 0;
    image_speed = 0;
    anim_timer = 0;
    anim_first = 0;
    anim_last = max(0, sprite_get_number(sprite_index) - 1);
  }
  anim_hold = _hold_steps;
  image_xscale = _flip_x ? -1 : 1;
}

function en_apply_idle_sprite() {
  if (cfg.kind == "slime") {
    en_apply_sprite(cfg.spr.idle, cfg.idle_hold_steps, false);
    return;
  }

  var flip = (facing == 2);
  var spr = en_spr_pick_dir(cfg.spr.idle, facing);
  en_apply_sprite(spr, cfg.idle_hold_steps, flip);
}

function en_apply_walk_sprite() {
  if (cfg.kind == "slime") {
    en_apply_sprite(cfg.spr.walk, cfg.walk_hold_steps, false);
    return;
  }

  var flip = (facing == 2);
  var spr = en_spr_pick_dir(cfg.spr.walk, facing);
  en_apply_sprite(spr, cfg.walk_hold_steps, flip);
}

function en_apply_attack_sprite() {
  if (cfg.kind == "slime") {
    en_apply_sprite(cfg.spr.walk, cfg.attack_hold_steps, false);
    return;
  }

  var f = atk_facing;
  var flip = (f == 2);
  var spr = en_spr_pick_dir(cfg.spr.attack, f);
  en_apply_sprite(spr, cfg.attack_hold_steps, flip);
}

function en_apply_dead_sprite() {
  if (cfg.kind == "slime") {
    en_apply_sprite(cfg.spr.hit, cfg.idle_hold_steps, false);
    return;
  }
  en_apply_sprite(cfg.spr.dead, cfg.idle_hold_steps, false);
}

function en_anim_update() {
  image_speed = 0;

  var moving = (abs(hsp) + abs(vsp) > 0.05);
  var in_attack = (state == EN_STATE.ATTACK_WINDUP || state == EN_STATE.ATTACK_ACTIVE || state == EN_STATE.ATTACK_RECOVERY);

  if (state == EN_STATE.DEAD) {
    en_apply_dead_sprite();
  } else if (in_attack) {
    en_apply_attack_sprite();
  } else if (moving && (state == EN_STATE.CHASE || state == EN_STATE.REPOSITION || state == EN_STATE.PATROL)) {
    en_apply_walk_sprite();
  } else {
    en_apply_idle_sprite();
  }

  anim_timer++;
  if (anim_timer >= anim_hold) {
    anim_timer = 0;
    var f = floor(image_index) + 1;
    if (f > anim_last) f = anim_first;
    image_index = f;
  }
}
