#region CONFIG
spd = 5.5;
dir = 0; // vai ser sobrescrito pelo player
life = 90;
dmg = 2;

solid_obj = asset_get_index("obj_solid");
#endregion

#region STATE
inited = false;
vx = 0;
vy = 0;
#endregion

#region VISUAL
image_speed = 0;
image_angle = 0;
#endregion
