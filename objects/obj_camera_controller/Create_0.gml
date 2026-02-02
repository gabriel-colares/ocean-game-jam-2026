view_w = 21 * 16;
view_h = 12 * 16;

global.en_debug = false;

depth = -1000;

ui_font = asset_get_index("Mgs");
if (ui_font == -1) ui_font = asset_get_index("fnt_Mgs");
if (ui_font == -1) ui_font = -1;

if (!variable_global_exists("intro_pending")) global.intro_pending = false;
if (!variable_global_exists("bgm_started")) global.bgm_started = false;

intro_pages = [
  "Introducao\n\nAnahi desperta com um silencio estranho.\nNao ha vozes, nao ha passos, nao ha vida.",
  "Ao sair de sua casa, a vila que antes conhecia esta irreconhecivel.\n\nCorpos espalham-se pelas ruas, imoveis, com olhares vazios e marcas de algo que nao deveria existir. O ar e pesado. O ceu, escuro demais para ser dia.",
  "Algo aconteceu durante a noite.\nAlgo tomou a vila... e nao deixou sobreviventes.",
  "Enquanto Anahi caminha entre os mortos, uma sensacao incomoda cresce em seu peito:\nisso nao foi apenas uma doenca.\n\nFoi o comeco de algo muito pior."
];

intro_active = false;
intro_page = 0;
intro_fade_alpha = 0;
intro_fade_out = false;
intro_fade_steps = max(1, ceil(room_speed * 0.5));

menu_hover = -1;
menu_show_credits = false;
menu_selected = 0;
menu_gui_x = 1000;
menu_start_y = 200;
menu_spacing = 60;
menu_button_w = 260;
menu_button_h = 44;
menu_gp = -1;
menu_start_phase = 0;
menu_start_timer = 0;
menu_wait_steps = max(1, ceil(room_speed * 1.0));
menu_fade_timer = 0;
menu_fade_steps = max(1, ceil(room_speed * 0.2));
menu_fade_alpha = 0;
menu_nav_cd = 0;

dead_interact_r = 28;
dead_prompt_obj = noone;
dead_prompt_text = "Aperte X para interagir";

dead_dialog_active = false;
dead_dialog_text = "";

death_panel_active = false;
death_panel_selected = 0;
death_panel_nav_cd = 0;

if (!variable_global_exists("respawn_target_active")) global.respawn_target_active = false;

if (!variable_global_exists("cam_shake_t")) global.cam_shake_t = 0;
if (!variable_global_exists("cam_shake_mag")) global.cam_shake_mag = 0;
if (!variable_global_exists("cam_shake_tmax")) global.cam_shake_tmax = 0;

if (!variable_global_exists("saci_stage")) global.saci_stage = 0;

saci_dialog_active = false;
saci_dialog_owner = noone;
saci_dialog_lines = [];
saci_dialog_lines2 = [
  "Anahi:\nQuem e voce? O que aconteceu com esse lugar?",
  "Saci:\nA vila adoeceu antes dos corpos carem. A escuridao chegou primeiro... depois, o resto seguiu.",
  "Anahi:\nIsso foi uma doenca?",
  "Saci:\nDoenca, maldicao, castigo... nomes diferentes pra mesma dor.",
  "(O Saci se aproxima e tira algo de dentro de seu gorro.)",
  "Saci:\nEssa mascara... ela chama quem escuta demais o escuro.",
  "Anahi:\nPor que me dar isso?",
  "Saci:\nPorque ela ja te escolheu. E porque sem ela... voce nao volta viva.",
  "Anahi:\nDe onde ela veio?",
  "Saci:\nAlgumas historias nao gostam de ser contadas. Outras mordem quem tenta.",
  "(Ele entrega a mascara.)",
  "Saci:\nUse quando a noite apertar. Mas lembre-se: toda ajuda cobra algo em troca.",
  "Anahi:\nE como eu paro isso?",
  "Saci:\nHehehe... se eu soubesse tudo, nao estaria aqui so observando.",
  "(O Saci desaparece em uma nuvem de fumaca.)"
];
saci_dialog_index = 0;
saci_dialog_text = "";

upgrade_fx_steps = max(1, ceil(room_speed * 1.6));
upgrade_fx_t = 0;

upgrade_wait_steps = max(1, ceil(room_speed * 0.5));
upgrade_wait_t = 0;

upgrade_dialog_active = false;
upgrade_dialog_text = "";

if (room == Menu) {
    var layer_anahi = layer_get_id("Anahi");
    if (layer_anahi != -1) layer_set_visible(layer_anahi, true);
    var layer_mask = layer_get_id("Anahi_Mask");
    if (layer_mask != -1) layer_set_visible(layer_mask, false);

    global.difficulty_level = 0;
    global.difficulty_timer = 0;

    global.bgm_started = false;
    var snd_bgm = asset_get_index("trilha_sonora");
    if (snd_bgm != -1) audio_stop_sound(snd_bgm);

    audio_stop_sound(menu);
    audio_play_sound(menu, 0, true);

    menu_start_phase = 0;
    menu_start_timer = 0;
    menu_fade_timer = 0;
    menu_fade_alpha = 0;

    menu_gp = pl_gamepad_find_first(11);
    view_enabled = false;
    view_visible[0] = false;
    exit;
}

if (global.intro_pending) {
    global.intro_pending = false;
    intro_active = true;
    intro_page = 0;
    intro_fade_alpha = 1;
    intro_fade_out = false;
}

audio_stop_sound(menu);

if (!intro_active) {
    var snd_bgm = asset_get_index("trilha_sonora");
    if (snd_bgm != -1) {
        if (!audio_is_playing(snd_bgm)) audio_play_sound(snd_bgm, 0, true);
        if (!variable_global_exists("bgm_started")) global.bgm_started = false;
        global.bgm_started = true;
    }
}

follow_lerp_x = 0.16;
follow_lerp_y = 0.10;

dead_w = view_w * 0.05;
dead_h = view_h * 0.08;

max_y_offset = 32;

target = noone;

view_enabled = true;
view_visible[0] = true;

cam = camera_create_view(0, 0, view_w, view_h, 0, noone, 0, 0, 0, 0);
view_camera[0] = cam;

bound_l = 0;
bound_t = 0;
bound_r = room_width;
bound_b = room_height;

base_y = room_height * 0.5;
