var ev = async_load[? "event_type"];

if (ev == "gamepad discovered") {
  var p = async_load[? "pad_index"];
  gamepad_set_axis_deadzone(p, pad_deadzone);

  if (pad_id == -1) pad_id = p;

} else if (ev == "gamepad lost") {
  var p2 = async_load[? "pad_index"];
  if (pad_id == p2) pad_id = -1;
}
