image_speed = 0.12;
image_alpha = 1;

saci_triggered = false;
saci_do_fade = false;
saci_seen = false;

saci_fade_steps = max(1, ceil(room_speed * 0.6));
saci_fade_dalpha = 1 / saci_fade_steps;

encounter_id = 1;
if (room == Aldeia_2) encounter_id = 2;
near_dist = 128;
if (encounter_id == 2) near_dist = 28;
