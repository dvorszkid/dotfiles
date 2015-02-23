-- {{{ Required libraries
local gears      = require("gears")
local awful      = require("awful")
awful.rules      = require("awful.rules")
require("awful.autofocus")
local wibox      = require("wibox")
local beautiful  = require("beautiful")
local naughty    = require("naughty")
-- plugins
local lain       = require("lain")
local tyrannical = require("tyrannical")
-- configs
local tools      = require("tools")
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

-- lain
lain.layout.termfair.nmaster   = 3
lain.layout.termfair.ncol      = 1
lain.layout.centerfair.nmaster = 3
lain.layout.centerfair.ncol    = 1

-- layout setup
local layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.fair,
    awful.layout.suit.tile,
    lain.layout.uselessfair.horizontal,
    lain.layout.uselesstile,
    lain.layout.uselessfair,
    lain.layout.termfair,
    lain.layout.centerfair,
    lain.layout.uselesspiral.dwindle
}

-- tyrannical init
dofile(conf_dir .. "/tags.lua")

-- beautiful init
beautiful.init(conf_dir .. "/theme.lua")
local titlebars_enabled = beautiful.titlebar_enabled == nil and (config.titlebars == true) or beautiful.titlebar_enabled

-- wallpaper
for s = 1, screen.count() do
	gears.wallpaper.maximized(config.wallpaperPath .. s, s, true)
end
-- }}}


-- {{{ Autostart apps
for _, app in pairs(apps.autostart["common"]) do
	tools.run_once(app)
end
if apps.autostart[hostname] ~= nil then
	for _, app in pairs(apps.autostart[hostname]) do
		tools.run_once(app)
	end
end
-- }}}


-- {{{ Wibox
markup = lain.util.markup

-- Textclock
mytextclock = awful.widget.textclock(' %b %d %a ' .. markup.bold(markup.big('%H:%M ')))

-- Calendar
lain.widgets.calendar:attach(mytextclock, {
	font = "DejaVu Sans Mono"
})

-- CPU widget
local cpuwidget = lain.widgets.cpu({
	settings = function()
		widget:set_markup(markup.fg.color(beautiful.fg_dark, " CPU ") .. cpu_now.usage .. "% ")
	end
})

-- MEM widget
local swapwidget = wibox.widget.textbox()
local memwidget = lain.widgets.mem({
	settings = function()
		widget:set_markup(markup.fg.color(beautiful.fg_dark, " RAM ") .. mem_now.used .. " MB ")
		swapwidget:set_markup(markup.fg.color(beautiful.fg_dark, " SWP ") .. mem_now.swapused .. " MB ")
	end
})

-- Net widget
local netdownicon = wibox.widget.imagebox(beautiful.net_down)
local netupicon = wibox.widget.imagebox(beautiful.net_up)
local netdownwidget = wibox.widget.textbox()
local netupwidget = lain.widgets.net({
	settings = function()
		netdownwidget:set_markup(markup(beautiful.c_green, net_now.received .. " "))
		widget:set_markup(markup(beautiful.c_red, net_now.sent .. " "))
	end
})

-- ALSA volume bar
local volumeicon = wibox.widget.imagebox(beautiful.vol)
volume = lain.widgets.alsabar({width = 55, ticks = true, ticks_size = 6, step = "4%",
	settings = function()
		if volume_now.status == "off" then
			volumeicon:set_image(beautiful.vol_mute)
		elseif volume_now.level <= 20 then
			volumeicon:set_image(beautiful.vol_no)
		elseif volume_now.level <= 50 then
			volumeicon:set_image(beautiful.vol_low)
		else
			volumeicon:set_image(beautiful.vol)
		end
	end,
	colors =
	{
		background = beautiful.bg_normal,
		mute = beautiful.bg_urgent,
		unmute = beautiful.fg_normal
	}
})
local volmargin = wibox.layout.margin(volume.bar, 2, 7)
volmargin:set_top(6)
volmargin:set_bottom(6)
local volumewidget = wibox.widget.background(volmargin)
volumewidget:set_bgimage(beautiful.widget_bg)

-- Separators
bar_spr = wibox.widget.textbox(' ' .. markup(beautiful.fg_dark, "|") .. ' ')

-- Create a wibox for each screen and add it
local mywibox = {}
mypromptbox = {}
local mylayoutbox = {}
local mytaglist = {}
mytaglist.buttons = keys.taglistButtons
local mytasklist = {}
mytasklist.buttons = keys.tasklistButtons

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()

    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)

    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s, height = 18 })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylayoutbox[s])
    left_layout:add(bar_spr)
    left_layout:add(mytaglist[s])
    left_layout:add(bar_spr)
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(bar_spr)
    if s == 1 then
		right_layout:add(wibox.widget.systray())
		right_layout:add(bar_spr)
	end
    right_layout:add(cpuwidget)
    right_layout:add(bar_spr)
    right_layout:add(memwidget)
    right_layout:add(bar_spr)
    right_layout:add(swapwidget)
    right_layout:add(bar_spr)
    right_layout:add(netdownicon)
    right_layout:add(netdownwidget)
    right_layout:add(bar_spr)
    right_layout:add(netupicon)
    right_layout:add(netupwidget)
    right_layout:add(bar_spr)
    right_layout:add(volumeicon)
    right_layout:add(volumewidget)
    right_layout:add(bar_spr)
    right_layout:add(mytextclock)

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
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
                     keys = keys.clientKeys,
                     buttons = keys.clientButtons,
	                 size_hints_honor = false } },
}
-- }}}


-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
	if config.sloppyFocus == true then
		c:connect_signal("mouse::enter", function(c)
			if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
				and awful.client.focus.filter(c) then
				client.focus = c
			end
		end)
	end

    if not startup and not c.size_hints.user_position
       and not c.size_hints.program_position then
        awful.placement.no_overlap(c)
        awful.placement.no_offscreen(c)
    end

    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.stickybutton(c))
        left_layout:add(awful.titlebar.widget.ontopbutton(c))

        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(keys.titlebarButtons)

        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_middle(middle_layout)
        layout:set_right(right_layout)

        awful.titlebar(c,{size=14}):set_widget(layout)
		if awful.layout.get(c.screen) ~= awful.layout.suit.floating then
			awful.titlebar.hide(c);
		end
    end
end)

client.connect_signal("focus", function(c)
	c.border_color = beautiful.border_focus
end)

client.connect_signal("unfocus", function(c)
	c.border_color = beautiful.border_normal
end)

client.connect_signal("property::floating", function(c)
	if awful.client.floating.get(c) then
		   awful.titlebar.show(c)
	else
		   awful.titlebar.hide(c)
	end
end)
-- }}}


-- {{{ Arrange signal handler
for s = 1, screen.count() do screen[s]:connect_signal("arrange", function ()
        local clients = awful.client.visible(s)
        local layout  = awful.layout.getname(awful.layout.get(s))

        if #clients > 0 then -- Fine grained borders and floaters control
            for _, c in pairs(clients) do -- Floaters always have borders
                if awful.client.floating.get(c) or layout == "floating" then
                    c.border_width = beautiful.border_width

                -- No borders with only one visible client
                elseif #clients == 1 or layout == "max" then
                    clients[1].border_width = 0
                else
                    c.border_width = beautiful.border_width
                end
            end
        end
      end)
end
-- }}}

