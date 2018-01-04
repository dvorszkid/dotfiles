-- {{{ Required libraries
-- Standard awesome libraries
local gears      = require("gears")
local awful      = require("awful")
awful.rules      = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox      = require("wibox")
-- Theme handling library
local beautiful  = require("beautiful")
-- Notification library
local naughty    = require("naughty")
-- Plugins
local lain       = require("lain")
local tyrannical = require("tyrannical")
-- Configs
local autostart  = require("autostart")
local apps       = require("apps")
local keys       = require("keys")
-- }}}


-- {{{ Error handling
-- Handle startup errors
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors
	})
end

-- Autostart
for _, cmd in pairs(autostart) do
	awful.util.spawn_with_shell("pgrep -u $USER -f \"" .. cmd .. "\"$ || (sleep 1 && " .. cmd .. ")")
end


-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error",
		function (err)
			-- Make sure we don't go into an endless error loop
			if in_error then return end
			in_error = true

			naughty.notify({
				preset = naughty.config.presets.critical,
				title = "Oops, an error happened!",
				text = err
			})
			in_error = false
		end)
end
-- }}}


-- {{{ Configuration
-- localization
os.setlocale(os.getenv("LANG"))

-- common
modkey		= "Mod4"
altkey		= "Mod1"
user		= os.getenv("USER")
home_dir	= os.getenv("HOME")
conf_dir	= awful.util.getdir("config")
terminal    = apps.cmd.terminal
hostname    = io.lines("/proc/sys/kernel/hostname")()

config = {}
config.titlebars     = true
config.sloppyFocus   = true
config.scr           = {
	pri = 1,
	sec = screen.count() > 1 and 2 or 1,
}
config.wallpaperPath = home_dir .. "/.local/share/wallpapers/"

if (hostname ~= "bp1-dsklin") then
	hostname = "bp1-dsklin"
end

-- lain
lain.layout.termfair.nmaster   = 3
lain.layout.termfair.ncol      = 1
lain.layout.termfair.center.nmaster = 3
lain.layout.termfair.center.ncol    = 1

-- layout setup
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.fair,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.top,
    awful.layout.suit.max,
    lain.layout.termfair,
    lain.layout.termfair.center,
}

-- tyrannical init
dofile(conf_dir .. "/tags.lua")

-- beautiful init
beautiful.init(conf_dir .. "/theme.lua")
local titlebars_enabled = beautiful.titlebar_enabled == nil and (config.titlebars == true) or beautiful.titlebar_enabled

-- wallpaper
local function set_wallpaper(s)
	local wallpaper = config.wallpaperPath .. s.index
	-- If wallpaper is a function, call it with the screen
	if type(wallpaper) == "function" then
		wallpaper = wallpaper(s)
	end
	gears.wallpaper.maximized(wallpaper, s, true)
end

-- re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)
-- }}}

-- {{{ Wibox
markup = lain.util.markup

-- Textclock
mytextclock = wibox.widget.textclock(' %b %d %a ' .. markup.bold(markup.big('%H:%M:%S ')), 1)

-- Calendar
local calendar = lain.widget.calendar({
	font = "DejaVu Sans Mono",
	attach_to = { mytextclock },
	followmouse = true
})

-- CPU widget
local cpuwidget = lain.widget.cpu({
	settings = function()
		widget:set_markup(markup.fg.color(beautiful.fg_dark, " CPU ") .. cpu_now.usage .. "% ")
	end
})

-- MEM widget
local memwidget = lain.widget.mem({
	settings = function()
		widget:set_markup(markup.fg.color(beautiful.fg_dark, " RAM ") .. mem_now.used .. " MB ")
	end
})

-- Net widget
local netdownicon = wibox.widget.imagebox(beautiful.net_down)
local netupicon = wibox.widget.imagebox(beautiful.net_up)
local netdownwidget = wibox.widget.textbox()
local netupwidget = lain.widget.net({
	settings = function()
		netdownwidget:set_markup(markup(beautiful.c_green, net_now.received .. " kB "))
		widget:set_markup(markup(beautiful.c_red, net_now.sent .. " kB "))
	end
})

-- ALSA widget
local volume = lain.widget.alsabar({
	timeout = 5,
	ticks = true,
	ticks_size = 5,
	height = 5,
	width = 50,
	colors = {
		background = beautiful.bg_normal,
		mute       = beautiful.fg_dark,
		unmute     = beautiful.fg_normal
	}
})
volume.bar:buttons(awful.util.table.join(
    awful.button({}, 1, function() -- left click
        awful.spawn(string.format("%s -e alsamixer", terminal))
    end),
    awful.button({}, 3, function() -- right click
        awful.spawn(string.format("%s set %s toggle", volume.cmd, volume.togglechannel or volume.channel))
        volume.update()
    end),
    awful.button({}, 4, function() -- scroll up
        awful.spawn(string.format("%s set %s 2%%+", volume.cmd, volume.channel))
        volume.update()
    end),
    awful.button({}, 5, function() -- scroll down
        awful.spawn(string.format("%s set %s 2%%-", volume.cmd, volume.channel))
        volume.update()
    end)
))
keys.globalKeys = awful.util.table.join(awful.util.table.join(
	awful.key({ }, "XF86AudioRaiseVolume", function () volume.update() end),
	awful.key({ }, "XF86AudioLowerVolume", function () volume.update() end),
	awful.key({ }, "XF86AudioMute", function ()
		os.execute("sleep 0.1")
		volume.update()
	end)
), keys.globalKeys)

-- Separators
bar_spr = wibox.widget.textbox(' ' .. markup(beautiful.fg_dark, "|") .. ' ')

-- Screen widgets
awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(keys.layoutButtons)

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, keys.taglistButtons, {},
		function (w, buttons, label, data, tags)
			local function mylabel(c)
				local text, bg_color, bg_image, icon, other_args = label(c)
				text = text:gsub(">" .. c.name .. "<", ">" .. c.index .. ": " .. c.name .. "<")
				return text, bg_color, bg_image, icon, other_args
			end
			return awful.widget.common.list_update(w, buttons, mylabel, data, tags)
		end)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, keys.tasklistButtons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = 18 })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        -- Left widgets
		{
			layout = wibox.layout.fixed.horizontal,
			s.mylayoutbox,
			bar_spr,
			s.mytaglist,
			bar_spr,
			s.mypromptbox,
        },
		-- Middle widget
        s.mytasklist,
        -- Right widgets
		{
			layout = wibox.layout.fixed.horizontal,
			bar_spr,
			cpuwidget.widget,
			bar_spr,
			memwidget.widget,
			bar_spr,
			netdownicon,
			netdownwidget,
			bar_spr,
			netupicon,
			netupwidget.widget,
			bar_spr,
			volume.bar,
			bar_spr,
			wibox.widget.systray(),
			mytextclock,
        },
    }
end)
-- }}}


-- {{{ Global keys and buttons
root.buttons(keys.rootButtons)
root.keys(keys.globalKeys)
-- }}}


-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = keys.clientKeys,
                     buttons = keys.clientButtons,
                     screen = awful.screen.preferred,
					 size_hints_honor = false,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
       }
      },

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = true }
    },
}
-- }}}


-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
        awful.placement.no_overlap(c)
	-- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

client.connect_signal("request::titlebars", function(c)
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        awful.titlebar(c) : setup {
            -- Left
            {
                awful.titlebar.widget.iconwidget(c),
                awful.titlebar.widget.stickybutton   (c),
                awful.titlebar.widget.ontopbutton    (c),
                buttons = buttons,
                layout  = wibox.layout.fixed.horizontal
            },
            -- Middle
            {
                { -- Title
                    align  = "center",
                    widget = awful.titlebar.widget.titlewidget(c)
                },
                buttons = keys.getTitlebarButtons(c),
                layout  = wibox.layout.flex.horizontal
            },
            -- Right
            {
                awful.titlebar.widget.floatingbutton (c),
                awful.titlebar.widget.maximizedbutton(c),
                awful.titlebar.widget.closebutton    (c),
                layout = wibox.layout.fixed.horizontal()
            },
            layout = wibox.layout.align.horizontal
        }
		awful.titlebar(c, {size=16})
		if not c.floating then
			awful.titlebar.hide(c)
		end
    end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

-- Focused border colors
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
