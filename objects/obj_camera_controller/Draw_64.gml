if (room == Menu) {
    var x0 = menu_gui_x;
    var y0 = menu_start_y;
    var s = menu_spacing;
    var w = menu_button_w;
    var h = menu_button_h;

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_font(ui_font);

    if (menu_show_credits) {
        var gw = display_get_gui_width();
        var gh = display_get_gui_height();
        draw_set_alpha(1);
        draw_set_color(c_black);
        draw_rectangle(0, 0, gw, gh, false);
        draw_set_color(c_white);
        draw_sprite_stretched(spr_creditos, 0, 0, 0, gw, gh);
        draw_set_font(-1);
        exit;
    }

    for (var i = 0; i < 3; i++) {
        var yy = y0 + i * s;

        draw_set_alpha(1);
        draw_set_color(c_white);
        draw_rectangle(x0, yy, x0 + w, yy + h, false);
        draw_set_color(c_black);
        draw_rectangle(x0, yy, x0 + w, yy + h, true);

        if (i == menu_selected) {
            draw_set_color(c_aqua);
            draw_rectangle(x0 - 2, yy - 2, x0 + w + 2, yy + h + 2, true);
            draw_rectangle(x0 - 1, yy - 1, x0 + w + 1, yy + h + 1, true);
        }
    }

    draw_set_color(c_black);
    draw_text(x0 + w * 0.5, y0 + h * 0.5, "START");
    draw_text(x0 + w * 0.5, y0 + s + h * 0.5, "CREDITS");
    draw_text(x0 + w * 0.5, y0 + s * 2 + h * 0.5, "EXIT");

    if (menu_fade_alpha > 0) {
        draw_set_alpha(menu_fade_alpha);
        draw_set_color(c_black);
        draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
        draw_set_alpha(1);
    }

    draw_set_font(-1);
    exit;
}

var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

draw_set_font(ui_font);

if (death_panel_active) {
    draw_set_alpha(1);
    draw_set_color(c_black);
    draw_rectangle(0, 0, gui_w, gui_h, false);

    var w = 360;
    var h = 200;
    var x1 = floor((gui_w - w) * 0.5);
    var y1 = floor((gui_h - h) * 0.5);
    var x2 = x1 + w;
    var y2 = y1 + h;

    draw_set_color(c_white);
    draw_rectangle(x1, y1, x2, y2, true);

    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    draw_text(x1 + w * 0.5, y1 + 18, "VOCE MORREU");

    var opt_y0 = y1 + 90;
    var opt_gap = 44;
    for (var i = 0; i < 2; i++) {
        var yy = opt_y0 + i * opt_gap;
        if (i == death_panel_selected) {
            draw_set_color(c_aqua);
            draw_rectangle(x1 + 24, yy - 6, x2 - 24, yy + 28, true);
        }
        draw_set_color(c_white);

        var label = (i == 0) ? "RESTART" : "SAIR";
        draw_text(x1 + w * 0.5, yy, label);
    }

    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(c_gray);
    draw_text(x1 + w * 0.5, y2 - 14, "X/ENTER: OK   O/ESC: SAIR");

    draw_set_font(-1);
    exit;
}

if (intro_active || intro_fade_out) {
    draw_set_alpha(intro_fade_alpha);
    draw_set_color(c_black);
    draw_rectangle(0, 0, gui_w, gui_h, false);
    draw_set_alpha(1);

    if (intro_active) {
        var m_intro = 20;
        var box_h_intro = 200;
        var ix1 = m_intro;
        var iy1 = gui_h - m_intro - box_h_intro;
        var ix2 = gui_w - m_intro;
        var iy2 = gui_h - m_intro;

        draw_set_color(c_black);
        draw_rectangle(ix1, iy1, ix2, iy2, false);
        draw_set_color(c_white);
        draw_rectangle(ix1, iy1, ix2, iy2, true);

        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        var pad_l_intro = 16;
        var pad_r_intro = 16;
        var pad_t_intro = 14;
        var wrap_w_intro = max(1, (ix2 - ix1) - (pad_l_intro + pad_r_intro));
        draw_text_ext(ix1 + pad_l_intro, iy1 + pad_t_intro, intro_pages[intro_page], 18, wrap_w_intro);
    }

    draw_set_font(-1);
    exit;
}

if (saci_dialog_active) {
    var m_s = 20;
    var box_h_s = 132;
    var sx1 = m_s;
    var sy1 = gui_h - m_s - box_h_s;
    var sx2 = gui_w - m_s;
    var sy2 = gui_h - m_s;

    draw_set_alpha(1);
    draw_set_color(c_black);
    draw_rectangle(sx1, sy1, sx2, sy2, false);
    draw_set_color(c_white);
    draw_rectangle(sx1, sy1, sx2, sy2, true);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    var pad_l_s = 16;
    var pad_r_s = 16;
    var pad_t_s = 14;
    var wrap_w_s = max(1, (sx2 - sx1) - (pad_l_s + pad_r_s));
    draw_text_ext(sx1 + pad_l_s, sy1 + pad_t_s, saci_dialog_text, 18, wrap_w_s);

    draw_set_font(-1);
    exit;
}

if (dead_dialog_active) {
    var m = 20;
    var box_h = 132;
    var x1 = m;
    var y1 = gui_h - m - box_h;
    var x2 = gui_w - m;
    var y2 = gui_h - m;

    draw_set_alpha(1);
    draw_set_color(c_black);
    draw_rectangle(x1, y1, x2, y2, false);
    draw_set_color(c_white);
    draw_rectangle(x1, y1, x2, y2, true);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    var pad_l = 16;
    var pad_r = 16;
    var pad_t = 14;
    var wrap_w = max(1, (x2 - x1) - (pad_l + pad_r));
    draw_text_ext(x1 + pad_l, y1 + pad_t, dead_dialog_text, 18, wrap_w);

    draw_set_font(-1);
    exit;
}

if (upgrade_dialog_active) {
    var m_u = 20;
    var box_h_u = 170;
    var ux1 = m_u;
    var uy1 = gui_h - m_u - box_h_u;
    var ux2 = gui_w - m_u;
    var uy2 = gui_h - m_u;

    draw_set_alpha(1);
    draw_set_color(c_black);
    draw_rectangle(ux1, uy1, ux2, uy2, false);
    draw_set_color(c_white);
    draw_rectangle(ux1, uy1, ux2, uy2, true);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    var pad_l_u = 16;
    var pad_r_u = 16;
    var pad_t_u = 14;
    var wrap_w_u = max(1, (ux2 - ux1) - (pad_l_u + pad_r_u));
    draw_text_ext(ux1 + pad_l_u, uy1 + pad_t_u, upgrade_dialog_text, 18, wrap_w_u);

    draw_set_font(-1);
    exit;
}

if (instance_exists(dead_prompt_obj)) {
    var vx = camera_get_view_x(cam);
    var vy = camera_get_view_y(cam);

    var wx = dead_prompt_obj.x;
    var wy = dead_prompt_obj.bbox_top - 6;

    var sx = ((wx - vx) / view_w) * gui_w;
    var sy = ((wy - vy) / view_h) * gui_h;

    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);

    draw_set_alpha(1);
    draw_set_color(c_black);
    draw_text(sx + 1, sy + 1, dead_prompt_text);
    draw_set_color(c_white);
    draw_text(sx, sy, dead_prompt_text);
}

if (upgrade_fx_t > 0) {
    var a = sqrt(upgrade_fx_t / max(1, upgrade_fx_steps));
    draw_set_alpha(0.55 * a);
    draw_set_color(c_white);
    draw_rectangle(0, 0, gui_w, gui_h, false);
    draw_set_alpha(1);
}

draw_set_font(-1);
