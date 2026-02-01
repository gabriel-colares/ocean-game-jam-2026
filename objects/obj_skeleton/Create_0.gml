/// Create Event - obj_skeleton

#region SPRITES
sprIdleDown = spr_skeleton_idle_down;   // 4 frames
sprIdleUp   = spr_skeleton_idle_up;     // 4 frames
sprIdleSide = spr_skeleton_idle_left;   // 4 frames (base LEFT)

sprWalkDown = spr_skeleton_walk_down;   // 4 frames
sprWalkUp   = spr_skeleton_walk_up;     // 4 frames
sprWalkSide = spr_skeleton_walk_left;   // 4 frames (base LEFT)

sprAtkDown  = spr_skeleton_attack_down; // 1 frame
sprAtkUp    = spr_skeleton_attack_up;   // 1 frame
sprAtkSide  = spr_skeleton_attack_left; // 1 frame  (base LEFT)

sprDead     = spr_skeleton_dead;        // 1 frame
#endregion

#region CONFIG
aggro_range   = 140;
give_up_range = 200;
attack_range  = 14;

move_speed = 1.35;
accel_move = 0.25;
decel_stop = 0.25;

idle_anim_speed = 0.12;
walk_anim_speed = 2;

attack_hold_steps = max(1, ceil(room_speed * 0.25));
#endregion

#region STATE
// 0=idle, 1=chase, 2=attack, 3=dead
state = 0;

hsp = 0;
vsp = 0;

facing = 0; // 0=down, 1=left, 2=right, 3=up
attack_timer = 0;
#endregion

#region HELPERS
function sk_approach(_cur, _target, _step) {
  if (_cur < _target) return min(_cur + _step, _target);
  if (_cur > _target) return max(_cur - _step, _target);
  return _cur;
}

function sk_set_sprite(_spr, _speed) {
  if (sprite_index != _spr) {
    sprite_index = _spr;
    image_index  = 0;
  }
  image_speed = _speed;
}

function sk_sprite_idle(_f) {
  if (_f == 0) return sprIdleDown;
  if (_f == 3) return sprIdleUp;
  return sprIdleSide;
}

function sk_sprite_walk(_f) {
  if (_f == 0) return sprWalkDown;
  if (_f == 3) return sprWalkUp;
  return sprWalkSide;
}

function sk_sprite_attack(_f) {
  if (_f == 0) return sprAtkDown;
  if (_f == 3) return sprAtkUp;
  return sprAtkSide;
}

function sk_update_facing(_dx, _dy) {
  if (abs(_dx) >= abs(_dy)) facing = (_dx >= 0) ? 2 : 1;
  else facing = (_dy >= 0) ? 0 : 3;
}
#endregion

#region VISUAL
sprite_index = sk_sprite_idle(facing);
image_index  = 0;
image_speed  = idle_anim_speed;
image_xscale = 1;
image_yscale = 1;
#endregion
