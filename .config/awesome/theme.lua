--[[

     Holo Awesome WM theme 3.0
     github.com/lcpz

--]]

local gears = require("gears")
local lain  = require("lain")
local awful = require("awful")
local wibox = require("wibox")

local string = string
local os = { getenv = os.getenv }
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

local theme                                     = {}
theme.icon_dir                                  = conf_dir .. "/icons"
theme.titlebar_dir                              = conf_dir .. "/titlebar"
theme.font                                      = "Roboto Condensed Medium 10"
theme.mono_font                                 = "Roboto Mono Medium For Powerline 10"
theme.taglist_font                              = "Roboto Condensed Medium 7"

theme.tasklist_plain_task_name                  = true
theme.tasklist_disable_icon                     = false
theme.useless_gap                               = 4

-- Solarized colors
theme.c_yellow  = "#b58900"
theme.c_orange  = "#cb4b16"
theme.c_red     = "#dc322f"
theme.c_magenta = "#d33682"
theme.c_violet  = "#6c71c4"
theme.c_blue    = "#268bd2"
theme.c_cyan    = "#2aa198"
theme.c_green   = "#859900"

theme.fg_normal                                 = "#BBBBBB"
theme.fg_dark                                   = "#999999"
theme.fg_focus                                  = "#0099CC"
theme.bg_focus                                  = "#303030"
theme.bg_normal                                 = "#242424"
theme.fg_urgent                                 = "#CC9393"
theme.bg_urgent                                 = "#006B8E"
theme.border_width                              = 1
theme.border_normal                             = "#252525"
theme.border_focus                              = "#0099CC"
theme.taglist_fg_focus                          = "#FFFFFF"
theme.tasklist_bg_normal                        = "#222222"
theme.tasklist_fg_focus                         = "#4CB7DB"
theme.bg_systray                                = theme.bg_focus
theme.menu_height                               = 20
theme.menu_width                                = 160
theme.menu_icon_size                            = 32
theme.awesome_icon                              = theme.icon_dir .. "/awesome_icon_white.png"
theme.awesome_icon_launcher                     = theme.icon_dir .. "/awesome_icon.png"
theme.taglist_squares_sel                       = theme.icon_dir .. "/square_sel.png"
theme.taglist_squares_unsel                     = theme.icon_dir .. "/square_unsel.png"
theme.spr_small                                 = theme.icon_dir .. "/spr_small.png"
theme.spr_very_small                            = theme.icon_dir .. "/spr_very_small.png"
theme.spr_right                                 = theme.icon_dir .. "/spr_right.png"
theme.spr_left                                  = theme.icon_dir .. "/spr_left.png"
theme.bar                                       = theme.icon_dir .. "/bar.png"
theme.bottom_bar                                = theme.icon_dir .. "/bottom_bar.png"
theme.mpdl                                      = theme.icon_dir .. "/mpd.png"
theme.mpd_on                                    = theme.icon_dir .. "/mpd_on.png"
theme.prev                                      = theme.icon_dir .. "/prev.png"
theme.nex                                       = theme.icon_dir .. "/next.png"
theme.stop                                      = theme.icon_dir .. "/stop.png"
theme.pause                                     = theme.icon_dir .. "/pause.png"
theme.play                                      = theme.icon_dir .. "/play.png"
theme.clock                                     = theme.icon_dir .. "/clock.png"
theme.calendar                                  = theme.icon_dir .. "/cal.png"
theme.cogwheel                                  = theme.icon_dir .. "/cogwheel.png"
theme.cpu                                       = theme.icon_dir .. "/cpu.png"
theme.memory                                    = theme.icon_dir .. "/memory.png"
theme.volume                                    = theme.icon_dir .. "/volume.png"
theme.net_up                                    = theme.icon_dir .. "/net_up.png"
theme.net_down                                  = theme.icon_dir .. "/net_down.png"

theme.layout_tile                               = theme.icon_dir .. "/tile.png"
theme.layout_tileleft                           = theme.icon_dir .. "/tileleft.png"
theme.layout_tilebottom                         = theme.icon_dir .. "/tilebottom.png"
theme.layout_tiletop                            = theme.icon_dir .. "/tiletop.png"
theme.layout_fairv                              = theme.icon_dir .. "/fairv.png"
theme.layout_fairh                              = theme.icon_dir .. "/fairh.png"
theme.layout_spiral                             = theme.icon_dir .. "/spiral.png"
theme.layout_dwindle                            = theme.icon_dir .. "/dwindle.png"
theme.layout_max                                = theme.icon_dir .. "/max.png"
theme.layout_fullscreen                         = theme.icon_dir .. "/fullscreen.png"
theme.layout_magnifier                          = theme.icon_dir .. "/magnifier.png"
theme.layout_floating                           = theme.icon_dir .. "/floating.png"

theme.titlebar_close_button_normal              = theme.titlebar_dir .. "/close_normal.png"
theme.titlebar_close_button_focus               = theme.titlebar_dir .. "/close_focus.png"
theme.titlebar_minimize_button_normal           = theme.titlebar_dir .. "/minimize_normal.png"
theme.titlebar_minimize_button_focus            = theme.titlebar_dir .. "/minimize_focus.png"
theme.titlebar_ontop_button_normal_inactive     = theme.titlebar_dir .. "/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive      = theme.titlebar_dir .. "/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active       = theme.titlebar_dir .. "/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active        = theme.titlebar_dir .. "/ontop_focus_active.png"
theme.titlebar_sticky_button_normal_inactive    = theme.titlebar_dir .. "/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive     = theme.titlebar_dir .. "/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active      = theme.titlebar_dir .. "/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active       = theme.titlebar_dir .. "/sticky_focus_active.png"
theme.titlebar_floating_button_normal_inactive  = theme.titlebar_dir .. "/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive   = theme.titlebar_dir .. "/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active    = theme.titlebar_dir .. "/floating_normal_active.png"
theme.titlebar_floating_button_focus_active     = theme.titlebar_dir .. "/floating_focus_active.png"
theme.titlebar_maximized_button_normal_inactive = theme.titlebar_dir .. "/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = theme.titlebar_dir .. "/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active   = theme.titlebar_dir .. "/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active    = theme.titlebar_dir .. "/maximized_focus_active.png"

-- lain related
theme.lain_icons         = os.getenv("HOME") ..
                           "/.config/awesome/lain/icons/layout/default/"
theme.layout_termfair    = theme.lain_icons .. "termfair.png"
theme.layout_centerfair  = theme.lain_icons .. "centerfair.png"  -- termfair.center
theme.layout_cascade     = theme.lain_icons .. "cascade.png"
theme.layout_cascadetile = theme.lain_icons .. "cascadetile.png" -- cascade.tile
theme.layout_centerwork  = theme.lain_icons .. "centerwork.png"
theme.layout_centerhwork = theme.lain_icons .. "centerworkh.png" -- centerwork.horizontal

local markup = lain.util.markup
local blue   = "#80CCE6"
local width_scaling = 1.0

function wrap_widget(icon_path, widget)
	local icon = wibox.widget.imagebox(icon_path)
	local background = wibox.container.background(widget, theme.bg_focus, gears.shape.rectangle)
	local margin = wibox.container.margin(background, 0, 0, 5, 5)
	return wibox.widget {
		icon,
		nil,
		margin,
		layout = wibox.layout.align.horizontal
	}
end

-- Clock
local mytextclock = wibox.widget.textclock(markup.font(theme.mono_font, markup(theme.fg_normal, "%H:%M:%S")), 1)
mytextclock.font = theme.font
-- mytextclock.forced_width = 60 * width_scaling
mytextclock.align = 'center'
local clock_widget = wrap_widget(theme.clock, mytextclock)

-- Calendar
local mytextcalendar = wibox.widget.textclock(markup.fontfg(theme.font, theme.fg_normal, "W%V, %d %b %a "))
local calendar_widget = wrap_widget(theme.calendar, mytextcalendar)
lain.widget.calendar({
    attach_to = { mytextclock, mytextcalendar },
    followtag = true,
    notification_preset = {
        fg = theme.fg_normal,
        bg = theme.bg_normal,
        position = "top_right",
        font = "Monospace 10"
    }
})

-- ALSA volume bar
local myalsabar = lain.widget.alsabar({
    notification_preset = { font = "Monospace 9"},
    --togglechannel = "IEC958,3",
    width = 80, height = 10, border_width = 0,
    colors = {
        background = "#383838",
        unmute     = "#80CCE6",
        mute       = "#FF9F9F"
    },
})
myalsabar.bar.paddings = 0
myalsabar.bar.margins = 7
local volume_widget = wrap_widget(theme.volume, myalsabar.bar)
theme.volume = myalsabar

-- CPU
local cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(markup.font(theme.font, cpu_now.usage .. " %"))
    end
})
cpu.widget.align = 'right'
cpu.widget.forced_width = 40 * width_scaling
local cpu_widget = wrap_widget(theme.cpu, cpu.widget)

-- MEM
local mem = lain.widget.mem({
    settings = function()
        widget:set_markup(markup.font(theme.font, mem_now.used .. " MiB"))
    end
})
mem.widget.align = 'right'
mem.widget.forced_width = 65 * width_scaling
local mem_widget = wrap_widget(theme.mem, mem.widget)

-- Net
local netdown = wibox.widget.textbox()
netdown.align = 'right'
netdown.forced_width = 75 * width_scaling
local netup = lain.widget.net({
	settings = function()
		netdown:set_markup(markup.font(theme.font, net_now.received .. " kB/s"))
		widget:set_markup(markup.font(theme.font, net_now.sent .. " kB/s"))
	end
})
netup.widget.align = 'right'
netup.widget.forced_width = 75 * width_scaling
local netdown_widget = wrap_widget(theme.net_down, netdown)
local netup_widget = wrap_widget(theme.net_up, netup.widget)

-- Separators
local spr_small = wibox.widget.imagebox(theme.spr_small)
local spr_very_small = wibox.widget.imagebox(theme.spr_very_small)
local spr_right = wibox.widget.imagebox(theme.spr_right)
local spr_left = wibox.widget.imagebox(theme.spr_left)
local bar = wibox.widget.imagebox(theme.bar)
local bottom_bar = wibox.widget.imagebox(theme.bottom_bar)

local barcolor  = gears.color({
    type  = "linear",
    from  = { 32, 0 },
    to    = { 32, 32 },
    stops = { {0, theme.bg_focus}, {0.8, "#505050"}, {1, theme.bg_urgent} }
})

function theme.at_screen_connect(s)
    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(awful.util.layoutbox_buttons)

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons, { bg_focus = barcolor }, s.mytaglist_func)

    mytaglistcont = wibox.container.background(s.mytaglist, theme.bg_focus, gears.shape.rectangle)
    s.mytag = wibox.container.margin(mytaglistcont, 0, 0, 5, 5)

	-- Systray with margin
	s.mysystray = wibox.widget.systray()
    s.mysystraycont = wibox.container.margin(wibox.container.background(s.mysystray, theme.bg_focus, gears.shape.rectangle), 0, 0, 5, 5)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons, { bg_focus = theme.bg_focus, shape = gears.shape.rectangle, shape_border_width = 5, shape_border_color = theme.tasklist_bg_normal, align = "center" })

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = 32 })
    s.mywiboxborder = awful.wibar({ position = "top", screen = s, height = 1, bg = theme.fg_focus, x = 0, y = 33})

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            spr_right,
            s.mylayoutbox,
            bottom_bar,
            s.mytag,
            spr_left,
            s.mypromptbox,
        },
        nil, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            spr_right,
            netdown_widget,
            bottom_bar,
            netup_widget,
            bottom_bar,
            cpu_widget,
            bottom_bar,
            mem_widget,
            bottom_bar,
            volume_widget,
            bottom_bar,
            calendar_widget,
            bottom_bar,
            clock_widget,
            spr_left,
        },
    }

    -- Create the bottom wibox
    s.mybottomwibox = awful.wibar({ position = "bottom", screen = s, border_width = 0, height = 32 })
    s.mybottomwiboxborder = awful.wibar({ position = "bottom", screen = s, height = 1, bg = theme.fg_focus, x = 0, y = 33})

    -- Add widgets to the bottom wibox
    s.mybottomwibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            spr_right,
			s.mysystraycont,
            spr_left,
        },
    }
end

return theme
