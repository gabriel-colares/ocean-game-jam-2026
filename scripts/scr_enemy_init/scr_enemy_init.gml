function en_init() {
  if (is_undefined(enemy_kind)) enemy_kind = "skeleton";
  cfg = en_cfg_get(enemy_kind);

  state = EN_STATE.IDLE;
  state_t = 0;
  atk_cd = irandom_range(0, cfg.attack_cooldown);
  atk_facing = 0;

  target_id = noone;
  last_seen_x = x;
  last_seen_y = y;
  last_seen_t = 999999;
  has_los = false;
  in_agro = false;
  los_t = irandom(cfg.los_interval);

  facing = 0;

  hsp = 0;
  vsp = 0;
  x_rem = 0;
  y_rem = 0;
  target_x = x;
  target_y = y;

  nav_want_move = false;
  nav_last_x = x;
  nav_last_y = y;
  nav_stuck_t = 0;
  nav_hit_x = false;
  nav_hit_y = false;
  nav_following = false;
  nav_side = (irandom(1) == 0) ? 1 : -1;
  nav_has_wp = false;
  nav_wp_x = x;
  nav_wp_y = y;
  nav_wp_t = 0;

  slot_id = -1;
  wants_attack = false;
  slot_x = x;
  slot_y = y;

  hp_max = cfg.hp_max;
  hp = hp_max;
  hitstun_t = 0;
  dead = false;

  solid_obj = asset_get_index("obj_solid");

  anim_timer = 0;
  anim_hold = cfg.idle_hold_steps;
  anim_first = 0;
  anim_last = 0;

  en_apply_idle_sprite();

  self.en_take_damage = function(_amount) {
    if (_amount <= 0) return false;
    if (dead) return false;
    hp = max(0, hp - _amount);
    cfg.on_hit(self, _amount);
    if (hp <= 0) {
      en_set_state(EN_STATE.DEAD);
    } else {
      en_set_state(EN_STATE.HITSTUN);
      hitstun_t = max(hitstun_t, 10);
    }
    return true;
  };
}
