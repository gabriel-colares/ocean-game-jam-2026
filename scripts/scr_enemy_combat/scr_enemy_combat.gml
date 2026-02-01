function en_combat_melee_basic(_me) {
  if (!instance_exists(_me.target_id)) return;
  if (_me.dead) return;

  var dmg = 1;
  if (!is_undefined(_me.cfg.attack_dmg)) dmg = _me.cfg.attack_dmg;

  var off = 10;
  var ox = 0;
  var oy = 0;
  var f = _me.atk_facing;
  switch (f) {
    case 0: ox = 0; oy = off; break;
    case 3: ox = 0; oy = -off; break;
    case 1: ox = -off; oy = 0; break;
    case 2: ox = off; oy = 0; break;
  }

  var hb = instance_create_layer(_me.x + ox, _me.y + oy, _me.layer, obj_hitbox_enemy);
  hb.owner_id = _me.id;
  hb.dmg = dmg;
  hb.facing = f;
  hb.life = max(1, _me.cfg.attack_active);
  hb.w = 14;
  hb.h = 14;
}

function en_combat_ranged_basic(_me) {
  if (!instance_exists(_me.target_id)) return;
  if (_me.dead) return;

  var p = instance_create_layer(_me.x, _me.y, _me.layer, obj_proj_enemy);
  p.dir = _me.atk_facing;
  p.dmg = _me.cfg.attack_dmg;
}
