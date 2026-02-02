if (room == Menu) {
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);

    menu_hover = -1;

    var x0 = menu_gui_x;
    var w = menu_button_w;
    var h = menu_button_h;

    if (menu_gp == -1 || !gamepad_is_connected(menu_gp)) {
        menu_gp = pl_gamepad_find_first(11);
    }

    if (menu_start_phase == 1) {
        menu_start_timer++;
        if (menu_start_timer >= menu_wait_steps) {
            menu_start_phase = 2;
            menu_fade_timer = 0;
            menu_fade_alpha = 0;
        }
        exit;
    }

    if (menu_start_phase == 2) {
        menu_fade_timer++;
        menu_fade_alpha = clamp(menu_fade_timer / menu_fade_steps, 0, 1);
        if (menu_fade_alpha >= 1) {
            audio_stop_sound(menu);
            global.intro_pending = true;
            room_goto(Aldeia_1);
        }
        exit;
    }

    if (!menu_show_credits) {
        for (var i = 0; i < 3; i++) {
            var y0 = menu_start_y + i * menu_spacing;
            if (point_in_rectangle(mx, my, x0, y0, x0 + w, y0 + h)) {
                menu_hover = i;
                break;
            }
        }
    }

    var click = mouse_check_button_pressed(mb_left);
    if (menu_show_credits) {
        var back = keyboard_check_pressed(vk_escape) || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space) || click;
        if (!back && menu_gp != -1) {
            back = gamepad_button_check_pressed(menu_gp, gp_face2) || gamepad_button_check_pressed(menu_gp, gp_start) || gamepad_button_check_pressed(menu_gp, gp_face1);
        }
        if (back) menu_show_credits = false;
        exit;
    }

    if (menu_hover != -1) menu_selected = menu_hover;

    if (menu_nav_cd > 0) menu_nav_cd--;

    var nav_up = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
    var nav_down = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));
    if (menu_gp != -1) {
        nav_up = nav_up || gamepad_button_check_pressed(menu_gp, gp_padu);
        nav_down = nav_down || gamepad_button_check_pressed(menu_gp, gp_padd);

        if (menu_nav_cd <= 0) {
            var ly = gamepad_axis_value(menu_gp, gp_axislv);
            if (ly <= -0.55) { nav_up = true; menu_nav_cd = max(1, ceil(room_speed * 0.18)); }
            if (ly >= 0.55) { nav_down = true; menu_nav_cd = max(1, ceil(room_speed * 0.18)); }
        }
    }

    if (nav_up) menu_selected = (menu_selected + 2) mod 3;
    if (nav_down) menu_selected = (menu_selected + 1) mod 3;

    var accept = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);
    if (!accept && menu_gp != -1) {
        accept = gamepad_button_check_pressed(menu_gp, gp_start) || gamepad_button_check_pressed(menu_gp, gp_face1);
    }
    if (click && menu_hover != -1) accept = true;

    if (keyboard_check_pressed(vk_escape)) game_end();

    if (accept) {
        switch (menu_selected) {
            case 0:
                var layer_anahi = layer_get_id("Anahi");
                if (layer_anahi != -1) layer_set_visible(layer_anahi, false);
                var layer_mask = layer_get_id("Anahi_Mask");
                if (layer_mask != -1) layer_set_visible(layer_mask, true);
                menu_start_phase = 1;
                menu_start_timer = 0;
                menu_fade_timer = 0;
                menu_fade_alpha = 0;
                break;
            case 1:
                menu_show_credits = true;
                break;
            case 2:
                audio_stop_sound(menu);
                game_end();
                break;
        }
    }
    exit;
}

if (!instance_exists(target)) {
    target = instance_find(obj_player, 0);
    if (!instance_exists(target)) exit;
    base_y = target.y;
}

var intro_accept = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);
var intro_gp = -1;
if (variable_instance_exists(target, "pad_id")) intro_gp = target.pad_id;
if (intro_gp == -1 || !gamepad_is_connected(intro_gp)) intro_gp = pl_gamepad_find_first(11);
if (!intro_accept && intro_gp != -1) {
    intro_accept = gamepad_button_check_pressed(intro_gp, gp_start) || gamepad_button_check_pressed(intro_gp, gp_face1);
}

var dialog_accept = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);
if (!dialog_accept && intro_gp != -1) {
    dialog_accept =
        gamepad_button_check_pressed(intro_gp, gp_start) ||
        gamepad_button_check_pressed(intro_gp, gp_face1) ||
        gamepad_button_check_pressed(intro_gp, gp_face2) ||
        gamepad_button_check_pressed(intro_gp, gp_face3);
}

var player_dead = false;
if (instance_exists(target)) {
    if (variable_instance_exists(target, "pl_dead") && target.pl_dead) player_dead = true;
    if (variable_instance_exists(target, "hp") && target.hp <= 0) player_dead = true;
}

if (player_dead && !death_panel_active) {
    death_panel_active = true;
    death_panel_selected = 0;
    death_panel_nav_cd = 0;
    if (variable_global_exists("respawn_restarting")) global.respawn_restarting = true;
}

if (death_panel_active) {
    dead_prompt_obj = noone;
    if (instance_exists(target)) target.pl_dialog_lock = true;

    if (death_panel_nav_cd > 0) death_panel_nav_cd--;

    var nav_up_d = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
    var nav_down_d = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));
    if (intro_gp != -1) {
        nav_up_d = nav_up_d || gamepad_button_check_pressed(intro_gp, gp_padu);
        nav_down_d = nav_down_d || gamepad_button_check_pressed(intro_gp, gp_padd);

        if (death_panel_nav_cd <= 0) {
            var ly_d = gamepad_axis_value(intro_gp, gp_axislv);
            if (ly_d <= -0.55) { nav_up_d = true; death_panel_nav_cd = max(1, ceil(room_speed * 0.18)); }
            if (ly_d >= 0.55) { nav_down_d = true; death_panel_nav_cd = max(1, ceil(room_speed * 0.18)); }
        }
    }

    if (nav_up_d) death_panel_selected = (death_panel_selected + 1) mod 2;
    if (nav_down_d) death_panel_selected = (death_panel_selected + 1) mod 2;

    var accept_d = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);
    if (!accept_d && intro_gp != -1) {
        accept_d = gamepad_button_check_pressed(intro_gp, gp_start) || gamepad_button_check_pressed(intro_gp, gp_face1);
    }

    var cancel_d = keyboard_check_pressed(vk_escape);
    if (!cancel_d && intro_gp != -1) cancel_d = gamepad_button_check_pressed(intro_gp, gp_face2);

    if (cancel_d) {
        game_end();
        exit;
    }

    if (accept_d) {
        switch (death_panel_selected) {
            case 0:
                if (!variable_global_exists("player_respawn_hp")) global.player_respawn_hp = 1;
                global.player_hp = global.player_respawn_hp;
                if (!variable_global_exists("respawn_target_active")) global.respawn_target_active = false;
                if (!variable_global_exists("respawn_target_room")) global.respawn_target_room = room;
                if (!variable_global_exists("respawn_target_x")) global.respawn_target_x = 0;
                if (!variable_global_exists("respawn_target_y")) global.respawn_target_y = 0;

                var rx = (instance_exists(target)) ? target.x : 0;
                var ry = (instance_exists(target)) ? target.y : 0;
                var best_d2 = 130;
                var best_x = 0;
                var best_y = 0;
                var n_r = instance_number(obj_respawn);
                for (var i_r = 0; i_r < n_r; i_r++) {
                    var r = instance_find(obj_respawn, i_r);
                    if (!instance_exists(r)) continue;
                    var dxr = r.x - rx;
                    var dyr = r.y - ry;
                    var d2r = dxr * dxr + dyr * dyr;
                    if (d2r < best_d2) {
                        best_d2 = d2r;
                        best_x = round(r.x);
                        best_y = round(r.y);
                    }
                }
                if (n_r <= 0) { best_x = round(rx); best_y = round(ry); }

                global.respawn_target_room = room;
                global.respawn_target_x = best_x;
                global.respawn_target_y = best_y;
                global.respawn_target_active = true;

                global.respawn_apply = true;
                room_restart();
                exit;
            case 1:
                game_end();
                exit;
        }
    }
    exit;
}

if (intro_active) {
    target.pl_dialog_lock = true;
    dead_prompt_obj = noone;
    if (intro_accept) {
        intro_page++;
        if (intro_page >= array_length_1d(intro_pages)) {
            intro_active = false;
            intro_fade_out = true;
        }
    }
} else if (intro_fade_out) {
    target.pl_dialog_lock = true;
    dead_prompt_obj = noone;
    intro_fade_alpha = clamp(intro_fade_alpha - (1 / intro_fade_steps), 0, 1);
    if (intro_fade_alpha <= 0) {
        intro_fade_alpha = 0;
        intro_fade_out = false;
        target.pl_dialog_lock = false;
    }
} else {
    if (saci_dialog_active) {
        dead_prompt_obj = noone;
        target.pl_dialog_lock = true;
        if (dialog_accept) {
            saci_dialog_index++;
            if (saci_dialog_index >= array_length_1d(saci_dialog_lines)) {
                saci_dialog_active = false;
                saci_dialog_text = "";
                if (instance_exists(target)) target.pl_dialog_lock = false;
                var next_stage = 1;
                var owner = saci_dialog_owner;
                if (instance_exists(owner)) {
                    if (variable_instance_exists(owner, "encounter_id") && owner.encounter_id == 2) next_stage = 2;
                    owner.saci_do_fade = true;
                }
                if (next_stage == 2) {
                    upgrade_fx_t = upgrade_fx_steps;
                    upgrade_wait_t = upgrade_wait_steps;
                    upgrade_dialog_text = "Habilidades adquiridas\n\nJogar lanca: botao O\nAtaque curto: botao Quadrado";

                    if (instance_exists(target)) {
                        if (variable_instance_exists(target, "pl_set_mask")) target.pl_set_mask(true);
                        if (variable_instance_exists(target, "hp_max")) target.hp = min(3, target.hp_max);
                        if (variable_instance_exists(target, "pl_dead")) target.pl_dead = false;
                        if (variable_instance_exists(target, "invuln_steps")) target.invuln_steps = 0;
                        if (variable_instance_exists(target, "hitstun_steps")) target.hitstun_steps = 0;
                        if (variable_instance_exists(target, "is_attacking")) target.is_attacking = false;
                        if (variable_instance_exists(target, "is_shooting")) target.is_shooting = false;
                    }
                    global.player_respawn_hp = 3;
                    if (instance_exists(target) && variable_instance_exists(target, "hp")) global.player_hp = target.hp;

                    if (instance_exists(owner)) {
                        for (var i_sm = 0; i_sm < 18; i_sm++) {
                            effect_create_above(ef_smoke, owner.x + random_range(-6, 6), owner.y + random_range(-6, 6), 1, c_gray);
                        }
                    }

                    if (instance_exists(target)) {
                        for (var i_sm2 = 0; i_sm2 < 18; i_sm2++) {
                            effect_create_above(ef_smoke, target.x + random_range(-6, 6), target.y + random_range(-6, 6), 1, c_gray);
                        }
                        effect_create_above(ef_ring, target.x, target.y, 1, c_aqua);
                        for (var i_sp = 0; i_sp < 12; i_sp++) {
                            effect_create_above(ef_spark, target.x + random_range(-8, 8), target.y + random_range(-10, 10), 1, c_white);
                        }
                    }
                }
                saci_dialog_owner = noone;
                if (global.saci_stage < next_stage) global.saci_stage = next_stage;
            } else {
                saci_dialog_text = saci_dialog_lines[saci_dialog_index];
            }
        }
    } else if (upgrade_dialog_active) {
        dead_prompt_obj = noone;
        target.pl_dialog_lock = true;
        if (dialog_accept) {
            upgrade_dialog_active = false;
            upgrade_dialog_text = "";
            if (instance_exists(target)) target.pl_dialog_lock = false;
        }
    } else if (dead_dialog_active) {
        dead_prompt_obj = noone;
        if (dialog_accept) {
            dead_dialog_active = false;
            if (instance_exists(target)) target.pl_dialog_lock = false;
        }
    } else {
        dead_prompt_obj = noone;
        var best_d2 = dead_interact_r * dead_interact_r;
        var px = target.x;
        var py = target.y;

        var n1 = instance_number(obj_npc_dead_1);
        for (var i1 = 0; i1 < n1; i1++) {
            var d1 = instance_find(obj_npc_dead_1, i1);
            var dx1 = d1.x - px;
            var dy1 = d1.y - py;
            var dd1 = dx1 * dx1 + dy1 * dy1;
            if (dd1 <= best_d2) {
                best_d2 = dd1;
                dead_prompt_obj = d1;
            }
        }

        var n2 = instance_number(obj_npc_dead_2);
        for (var i2 = 0; i2 < n2; i2++) {
            var d2 = instance_find(obj_npc_dead_2, i2);
            var dx2 = d2.x - px;
            var dy2 = d2.y - py;
            var dd2 = dx2 * dx2 + dy2 * dy2;
            if (dd2 <= best_d2) {
                best_d2 = dd2;
                dead_prompt_obj = d2;
            }
        }

        var n3 = instance_number(obj_npc_dead_3);
        for (var i3 = 0; i3 < n3; i3++) {
            var d3 = instance_find(obj_npc_dead_3, i3);
            var dx3 = d3.x - px;
            var dy3 = d3.y - py;
            var dd3 = dx3 * dx3 + dy3 * dy3;
            if (dd3 <= best_d2) {
                best_d2 = dd3;
                dead_prompt_obj = d3;
            }
        }

        var dead_accept = keyboard_check_pressed(vk_enter);
        if (!dead_accept && intro_gp != -1) dead_accept = gamepad_button_check_pressed(intro_gp, gp_face1);
        if (instance_exists(dead_prompt_obj) && dead_accept) {
            dead_dialog_active = true;
            target.pl_dialog_lock = true;

            if (dead_prompt_obj.object_index == obj_npc_dead_1) {
                dead_dialog_text = "O corpo esta frio e umido. O cheiro salgado nao combina com a terra seca ao redor.";
            } else if (dead_prompt_obj.object_index == obj_npc_dead_2) {
                dead_dialog_text = "A pele tem marcas antigas, como arranhoes. Voce desvia o olhar antes de entender o resto.";
            } else {
                dead_dialog_text = "Ha areia presa sob as unhas. O braco esta rigido, como se ainda tentasse se arrastar para longe.";
            }
        }
    }
}

if (upgrade_fx_t > 0) upgrade_fx_t--;

if (!saci_dialog_active && !dead_dialog_active && !intro_active && !intro_fade_out && !upgrade_dialog_active) {
    if (upgrade_fx_t <= 0 && upgrade_wait_t > 0) upgrade_wait_t--;
    if (upgrade_fx_t <= 0 && upgrade_wait_t <= 0 && upgrade_dialog_text != "") {
        upgrade_dialog_active = true;
        if (instance_exists(target)) target.pl_dialog_lock = true;
    }
}

if (upgrade_fx_t > 0 || upgrade_wait_t > 0 || upgrade_dialog_active) {
    dead_prompt_obj = noone;
    if (instance_exists(target)) target.pl_dialog_lock = true;
}

var b = instance_find(obj_camera_bounds, 0);
if (instance_exists(b)) {
    bound_l = b.bound_l;
    bound_t = b.bound_t;
    bound_r = b.bound_r;
    bound_b = b.bound_b;
}

var cx = camera_get_view_x(cam);
var cy = camera_get_view_y(cam);

var center_x = cx + view_w * 0.5;
var center_y = cy + view_h * 0.5;

var tx = target.x;
var ty = target.y;

var dx = tx - center_x;
if (abs(dx) > dead_w * 0.5) {
    center_x += (dx - sign(dx) * dead_w * 0.5);
}

base_y = lerp(base_y, ty, 0.05);

var dy = ty - center_y;
if (abs(dy) > dead_h * 0.5) {
    center_y += (dy - sign(dy) * dead_h * 0.5);
}

center_y = clamp(center_y, base_y - max_y_offset, base_y + max_y_offset);

var desired_x = center_x - view_w * 0.5;
var desired_y = center_y - view_h * 0.5;

cx = lerp(cx, desired_x, follow_lerp_x);
cy = lerp(cy, desired_y, follow_lerp_y);

cx = clamp(cx, bound_l, bound_r - view_w);
cy = clamp(cy, bound_t, bound_b - view_h);

cx = floor(cx);
cy = floor(cy);

camera_set_view_pos(cam, cx, cy);
