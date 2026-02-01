enum EN_STATE {
  IDLE,
  PATROL,
  ALERT,
  CHASE,
  REPOSITION,
  ATTACK_WINDUP,
  ATTACK_ACTIVE,
  ATTACK_RECOVERY,
  HITSTUN,
  DEAD
}

function en_state_name(_st) {
  static names = [
    "IDLE",
    "PATROL",
    "ALERT",
    "CHASE",
    "REPOSITION",
    "ATTACK_WINDUP",
    "ATTACK_ACTIVE",
    "ATTACK_RECOVERY",
    "HITSTUN",
    "DEAD"
  ];
  if (_st < 0 || _st >= array_length_1d(names)) return "UNKNOWN";
  return names[_st];
}

function en_spr_dir3(_down, _left, _up) {
  return { down: _down, left: _left, up: _up };
}

function en_cfg_get(_kind) {
  static defs = undefined;
  if (is_undefined(defs)) {
    defs = {};

    defs.skeleton = {
      kind: "skeleton",
      hp_max: 3,
      attack_dmg: 1,
      move_speed: 1.2,
      accel_move: 0.25,
      decel_stop: 0.30,

      agro_radius: 140,
      lose_sight_time: 60,
      react_time: 12,
      los_interval: 8,
      fov: 360,

      sep_radius: 14,
      sep_force: 0.12,

      attack_range: 18,
      attack_windup: 16,
      attack_active: 6,
      attack_recovery: 18,
      attack_cooldown: 25,

      max_attackers: 2,
      slot_radius: 26,
      slot_hold_ms: 250,

      idle_hold_steps: 12,
      walk_hold_steps: 8,
      attack_hold_steps: 10,

      spr: {
        idle: en_spr_dir3(spr_skeleton_idle_down, spr_skeleton_idle_left, spr_skeleton_idle_up),
        walk: en_spr_dir3(spr_skeleton_walk_down, spr_skeleton_walk_left, spr_skeleton_walk_up),
        attack: en_spr_dir3(spr_skeleton_attack_down, spr_skeleton_attack_left, spr_skeleton_attack_up),
        dead: spr_skeleton_dead
      },

      do_attack: function(_me) {
        en_combat_melee_basic(_me);
      },
      on_hit: function(_me, _dmg) { }
    };

    defs.monkey = {
      kind: "monkey",
      hp_max: 2,
      attack_dmg: 1,
      move_speed: 1.6,
      accel_move: 0.30,
      decel_stop: 0.35,

      agro_radius: 150,
      lose_sight_time: 55,
      react_time: 10,
      los_interval: 8,
      fov: 360,

      sep_radius: 14,
      sep_force: 0.13,

      attack_range: 16,
      attack_windup: 12,
      attack_active: 6,
      attack_recovery: 16,
      attack_cooldown: 22,

      max_attackers: 2,
      slot_radius: 24,
      slot_hold_ms: 250,

      idle_hold_steps: 12,
      walk_hold_steps: 7,
      attack_hold_steps: 9,

      spr: {
        idle: en_spr_dir3(spr_monkey_idle_down, spr_monkey_idle_left, spr_monkey_idle_up),
        walk: en_spr_dir3(spr_monkey_walk_down, spr_monkey_walk_left, spr_monkey_walk_up),
        attack: en_spr_dir3(spr_monkey_attack_down, spr_monkey_attack_left, spr_monkey_attack_up),
        dead: spr_monkey_dead
      },

      do_attack: function(_me) {
        en_combat_melee_basic(_me);
      },
      on_hit: function(_me, _dmg) { }
    };

    defs.nita = {
      kind: "nita",
      hp_max: 4,
      attack_dmg: 1,
      move_speed: 1.1,
      accel_move: 0.22,
      decel_stop: 0.28,

      agro_radius: 160,
      lose_sight_time: 70,
      react_time: 14,
      los_interval: 10,
      fov: 360,

      sep_radius: 14,
      sep_force: 0.10,

      attack_range: 20,
      attack_windup: 18,
      attack_active: 7,
      attack_recovery: 20,
      attack_cooldown: 30,

      max_attackers: 1,
      slot_radius: 28,
      slot_hold_ms: 280,

      idle_hold_steps: 14,
      walk_hold_steps: 8,
      attack_hold_steps: 11,

      spr: {
        idle: en_spr_dir3(spr_nita_idle_down, spr_nita_idle_left, spr_nita_idle_down),
        walk: en_spr_dir3(spr_nita_walk_down, spr_nita_walk_left, spr_nita_walk_up),
        attack: en_spr_dir3(spr_nita_attack_down, spr_nita_attack_left, spr_nita_attack_up),
        dead: spr_nita_dead
      },

      do_attack: function(_me) {
        en_combat_melee_basic(_me);
      },
      on_hit: function(_me, _dmg) { }
    };

    defs.slime = {
      kind: "slime",
      hp_max: 2,
      attack_dmg: 1,
      move_speed: 0.95,
      accel_move: 0.18,
      decel_stop: 0.22,

      agro_radius: 120,
      lose_sight_time: 45,
      react_time: 8,
      los_interval: 10,
      fov: 360,

      sep_radius: 12,
      sep_force: 0.15,

      attack_range: 14,
      attack_windup: 10,
      attack_active: 6,
      attack_recovery: 14,
      attack_cooldown: 18,

      max_attackers: 2,
      slot_radius: 22,
      slot_hold_ms: 200,

      idle_hold_steps: 12,
      walk_hold_steps: 10,
      attack_hold_steps: 10,

      spr: {
        idle: spr_slime_idle,
        walk: spr_slime_walk,
        hit: spr_slime_damage
      },

      do_attack: function(_me) {
        en_combat_melee_basic(_me);
      },
      on_hit: function(_me, _dmg) { }
    };
  }

  if (is_string(_kind)) {
    var k = string_lower(_kind);
    if (variable_struct_exists(defs, k)) return defs[$ k];
  }
  return defs.skeleton;
}
