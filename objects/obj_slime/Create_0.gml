/// Create Event - obj_slime

#region SPRITES
sprWalk = spr_slime_walk;       // 6 frames
sprDmg  = spr_slime_damage;     // 6 frames
sprIdle  = spr_slime_idle;     // 2 frames
#endregion

#region CONFIG
aggro_range   = 120;  // começa perseguir
give_up_range = 180;  // para perseguir (histerese)

move_speed = 1.25;
accel_move = 0.20;
decel_stop = 0.25;

padrao_left = true;            // sprite horizontal aponta pra esquerda
use_vertical_flip_for_up = false; // true se quiser tentar flipar no Y quando subir
#endregion

#region STATE
// 0=idle, 1=chase, 2=hurt
state = 0;

hsp = 0;
vsp = 0;

face_axis = 0; // 0=horizontal, 1=vertical (só pra decidir flip opcional)
#endregion

#region HURT
hurt_timer = 0;
hurt_hold_steps = 6; // 6 frames (0..5)
#endregion

#region VISUAL
sprite_index = sprWalk;
image_index  = 0;
image_speed  = 0.20; // ~12fps em room_speed 60
image_xscale = 1;    // 1 = LEFT (padrão)
image_yscale = 1;
#endregion

#region HELPERS
function sl_approach(_cur, _target, _step) {
  if (_cur < _target) return min(_cur + _step, _target);
  if (_cur > _target) return max(_cur - _step, _target);
  return _cur;
}

function sl_set_sprite(_spr, _speed) {
  if (sprite_index != _spr) {
    sprite_index = _spr;
    image_index  = 0;
  }
  image_speed = _speed;
}

// chame isso quando o slime tomar dano
self.sl_take_damage = function() {
  state = 2;
  hurt_timer = 0;

  sl_set_sprite(sprDmg, 0);
  image_index = 0;
};
#endregion
