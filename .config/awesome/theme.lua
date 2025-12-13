--[[
     Based on Holo Awesome WM theme 3.0
     github.com/lcpz
--]]

local theme = {}
theme.icon_dir = conf_dir .. "/icons"
theme.titlebar_dir = conf_dir .. "/titlebar"
if config.dpi_scaling > 1.1 then
    theme.font = "Roboto Condensed Medium 9"
    theme.mono_font = "Roboto Mono Medium For Powerline 9"
else
    theme.font = "Roboto Condensed Medium 10"
    theme.mono_font = "Roboto Mono Medium For Powerline 10"
end
theme.taglist_font = "Roboto Condensed Medium 7"
theme.tooltip_font = theme.font

theme.tasklist_plain_task_name = true
theme.tasklist_disable_icon = false
theme.useless_gap = 4

-- Solarized colors
theme.c_yellow = "#b58900"
theme.c_orange = "#cb4b16"
theme.c_red = "#dc322f"
theme.c_magenta = "#d33682"
theme.c_violet = "#6c71c4"
theme.c_blue = "#268bd2"
theme.c_cyan = "#2aa198"
theme.c_green = "#859900"

theme.fg_normal = "#BBBBBB"
theme.fg_dark = "#999999"
theme.fg_focus = "#0099CC"
theme.bg_focus = "#303030"
theme.bg_normal = "#242424"
theme.fg_urgent = "#CC9393"
theme.bg_urgent = "#006B8E"
theme.border_width = 1
theme.border_normal = "#252525"
theme.border_focus = theme.fg_focus
theme.taglist_fg_focus = "#FFFFFF"
theme.tasklist_bg_normal = "#222222"
theme.tasklist_fg_focus = "#4CB7DB"
theme.bg_systray = theme.bg_focus
theme.menu_height = 20 * config.dpi_scaling
theme.menu_width = 300 * config.dpi_scaling
theme.menu_icon_size = 32

theme.tooltip_bg = theme.bg_normal
theme.tooltip_fg = theme.fg_normal
theme.tooltip_border_color = theme.border_focus
theme.tooltip_border_width = theme.border_width

theme.awesome_icon = theme.icon_dir .. "/awesome_icon_white.png"
theme.awesome_icon_launcher = theme.icon_dir .. "/awesome_icon.png"
theme.taglist_squares_sel = theme.icon_dir .. "/square_sel.png"
theme.taglist_squares_unsel = theme.icon_dir .. "/square_unsel.png"
theme.spr_small = theme.icon_dir .. "/spr_small.png"
theme.spr_very_small = theme.icon_dir .. "/spr_very_small.png"
theme.spr_right = theme.icon_dir .. "/spr_right.png"
theme.spr_left = theme.icon_dir .. "/spr_left.png"
theme.bar = theme.icon_dir .. "/bar.png"
theme.bottom_bar = theme.icon_dir .. "/bottom_bar.png"
theme.mpdl = theme.icon_dir .. "/mpd.png"
theme.mpd_on = theme.icon_dir .. "/mpd_on.png"
theme.prev = theme.icon_dir .. "/prev.png"
theme.nex = theme.icon_dir .. "/next.png"
theme.stop = theme.icon_dir .. "/stop.png"
theme.pause = theme.icon_dir .. "/pause.png"
theme.play = theme.icon_dir .. "/play.png"
theme.clock = theme.icon_dir .. "/clock.png"
theme.calendar = theme.icon_dir .. "/cal.png"
theme.cogwheel = theme.icon_dir .. "/cogwheel.png"
theme.cpu = theme.icon_dir .. "/cpu.png"
theme.mem = theme.icon_dir .. "/mem.png"
theme.volume = theme.icon_dir .. "/volume.png"
theme.net_up = theme.icon_dir .. "/net_up.png"
theme.net_down = theme.icon_dir .. "/net_down.png"
theme.do_not_disturb = theme.icon_dir .. "/do_not_disturb.png"

theme.layout_tile = theme.icon_dir .. "/tile.png"
theme.layout_tileleft = theme.icon_dir .. "/tileleft.png"
theme.layout_tilebottom = theme.icon_dir .. "/tilebottom.png"
theme.layout_tiletop = theme.icon_dir .. "/tiletop.png"
theme.layout_fairv = theme.icon_dir .. "/fairv.png"
theme.layout_fairh = theme.icon_dir .. "/fairh.png"
theme.layout_spiral = theme.icon_dir .. "/spiral.png"
theme.layout_dwindle = theme.icon_dir .. "/dwindle.png"
theme.layout_max = theme.icon_dir .. "/max.png"
theme.layout_fullscreen = theme.icon_dir .. "/fullscreen.png"
theme.layout_magnifier = theme.icon_dir .. "/magnifier.png"
theme.layout_floating = theme.icon_dir .. "/floating.png"

theme.titlebar_close_button_normal = theme.titlebar_dir .. "/close_normal.png"
theme.titlebar_close_button_focus = theme.titlebar_dir .. "/close_focus.png"
theme.titlebar_minimize_button_normal = theme.titlebar_dir .. "/minimize_normal.png"
theme.titlebar_minimize_button_focus = theme.titlebar_dir .. "/minimize_focus.png"
theme.titlebar_ontop_button_normal_inactive = theme.titlebar_dir .. "/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive = theme.titlebar_dir .. "/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = theme.titlebar_dir .. "/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active = theme.titlebar_dir .. "/ontop_focus_active.png"
theme.titlebar_sticky_button_normal_inactive = theme.titlebar_dir .. "/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive = theme.titlebar_dir .. "/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = theme.titlebar_dir .. "/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active = theme.titlebar_dir .. "/sticky_focus_active.png"
theme.titlebar_floating_button_normal_inactive = theme.titlebar_dir .. "/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive = theme.titlebar_dir .. "/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = theme.titlebar_dir .. "/floating_normal_active.png"
theme.titlebar_floating_button_focus_active = theme.titlebar_dir .. "/floating_focus_active.png"
theme.titlebar_maximized_button_normal_inactive = theme.titlebar_dir .. "/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive = theme.titlebar_dir .. "/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = theme.titlebar_dir .. "/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active = theme.titlebar_dir .. "/maximized_focus_active.png"

-- lain related
theme.lain_icons = home_dir .. "/.config/awesome/lain/icons/layout/default/"
theme.layout_termfair = theme.lain_icons .. "termfair.png"
theme.layout_centerfair = theme.lain_icons .. "centerfair.png" -- termfair.center
theme.layout_cascade = theme.lain_icons .. "cascade.png"
theme.layout_cascadetile = theme.lain_icons .. "cascadetile.png" -- cascade.tile
theme.layout_centerwork = theme.lain_icons .. "centerwork.png"
theme.layout_centerhwork = theme.lain_icons .. "centerworkh.png" -- centerwork.horizontal

return theme
