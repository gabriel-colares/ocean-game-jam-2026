/// scr_player_init_shoot.gml
function pl_init_shoot() {
  #region TIRO (LANÇA)
  // mais seguro que "proj_obj = obj_spear_proj" caso o asset não exista ainda
  proj_obj = asset_get_index("obj_spear_proj");

  shoot_cooldown_max = 12;
  shoot_cooldown     = 0;

  // ajuste fino (16x16) para alinhar na mão
  shoot_hand_y_side = 2; // left/right (aumente pra descer)
  shoot_hand_y_ud   = 0; // up/down (se precisar)
  #endregion
}
