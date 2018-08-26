local awful        = require("awful")
local beautiful    = require("beautiful")
local lain         = require("lain")
local apps         = require("apps")
local hotkeys_popup = require("awful.hotkeys_popup").widget

modkey = "Mod4"
local altkey = "Mod1"

-- Setup global menu keys
awful.menu.menu_keys.up    = { "k", "Up"}
awful.menu.menu_keys.down  = { "j", "Down"}
awful.menu.menu_keys.enter = { "l", "Right"}
awful.menu.menu_keys.back  = { "h", "Left"}

-- Root buttons
local rootButtons = awful.util.table.join(
	awful.button({ }, 3, function () end),
	awful.button({ }, 4, awful.tag.viewnext),
	awful.button({ }, 5, awful.tag.viewprev)
)

-- Layout buttons
local layoutButtons = awful.util.table.join(
	awful.button({ }, 1, function () awful.layout.inc( 1) end),
    awful.button({ }, 3, function () awful.layout.inc(-1) end),
    awful.button({ }, 4, function () awful.layout.inc( 1) end),
    awful.button({ }, 5, function () awful.layout.inc(-1) end))

-- Taglist buttons
local taglistButtons = awful.util.table.join(
	awful.button({        }, 1, function(t) t:view_only() end),
	awful.button({        }, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 1, awful.client.movetotag),
	awful.button({ modkey }, 3, awful.client.toggletag),
	awful.button({        }, 4, function(t) awful.tag.viewprev(t.screen) end),
	awful.button({        }, 5, function(t) awful.tag.viewnext(t.screen) end)
)

-- Tasklist buttons
local tasklistButtons = awful.util.table.join(
	awful.button({ }, 1,
		function (c)
			if c == client.focus then
				c.minimized = true
			else
			-- Without this, the following
			-- :isvisible() makes no sense
				c.minimized = false
				if not c:isvisible() and c.first_tag then
					c.first_tag:view_only()
				end
				-- This will also un-minimize
				-- the client, if needed
				client.focus = c
				c:raise()
			end
		end),
	awful.button({ }, 3,
		function ()
			if instance then
				instance:hide()
				instance = nil
			else
				instance = awful.menu.clients({ width=250 })
			end
		end),
	awful.button({ }, 4,
		function ()
			awful.client.focus.byidx(-1)
			if client.focus then client.focus:raise() end
		end),
	awful.button({ }, 5,
		function ()
			awful.client.focus.byidx(1)
			if client.focus then client.focus:raise() end
		end)
)

-- Client keys
local clientKeys = awful.util.table.join(
	awful.key({ modkey,  altkey   }, "f"     , function (c) c.fullscreen = not c.fullscreen end, {description="toggle fullscreen", group="client modifiers"}),
	awful.key({ modkey, "Control" }, "c"     , function (c) c:kill() end, {description="kill", group="client modifiers"}),
	awful.key({ modkey,           }, "f"     , awful.client.floating.toggle, {description="toggle floating", group="client modifiers"}),
	awful.key({ modkey,           }, "o"     , function (c) c:move_to_screen() end, {description="move to next screen", group="client modifiers"}),
	awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end, {description="set as master", group="client modifiers"}),
	awful.key({ modkey,           }, "t"     , function (c) c.ontop = not c.ontop end, {description="toggle ontop", group="client modifiers"}),
	awful.key({ modkey,  altkey   }, "t"     , awful.titlebar.toggle, {description="toggle titlebar", group="client modifiers"}),
	awful.key({ modkey,           }, "s"     , function (c) c.sticky = not c.sticky end, {description="toggle sticky", group="client modifiers"}),
	awful.key({ modkey,           }, "n"     , function (c) c.minimized = true end, {description="minimize", group="client modifiers"}),
	awful.key({ modkey,           }, "m"     , function (c)
		c.maximized_horizontal = not c.maximized_horizontal
		c.maximized_vertical   = not c.maximized_vertical
	end, {description="toggle maximixed", group="client modifiers"})
)

-- Client buttons
local clientButtons = awful.util.table.join(
	awful.button({        }, 1, function (c) client.focus = c; c:raise() end),
	awful.button({ modkey }, 1, awful.mouse.client.move),
	awful.button({ modkey }, 3, awful.mouse.client.resize)
)

-- Titlebar buttons
local getTitlebarButtons = function (c)
	return awful.util.table.join(
		awful.button({ }, 1, function()
			client.focus = c
			c:raise()
			awful.mouse.client.move(c)
		end),
		awful.button({ }, 3, function()
			client.focus = c
			c:raise()
			awful.mouse.client.resize(c)
		end)
	)
end

-- Dropdown terminal
local quake = lain.util.quake({
	app = "urxvtc",
	extra = "-e " .. apps.cmd.tmuxs .. "dropdown",
	onlyone = true,
	followtag = true,
	height = 0.7,
})

local move_tag_to_screen = function(dir)
	local tag = awful.screen.focused().selected_tag
	local s = awful.screen.focused():get_next_in_direction(dir)
	if s then
		for _, t in pairs(s.selected_tags) do
			t.selected = false
		end
		tag.screen =  s
		mouse.screen = s
	end
end

-- Global keys
local globalKeys = awful.util.table.join(
	-- Awesome control
	awful.key({ modkey, "Control" }, "r",      awesome.restart, {description="restart", group="awesome"}),
	awful.key({ modkey, "Control" }, "q",      awesome.quit, {description="quit", group="awesome"}),
	awful.key({ modkey, "Control" }, "h" , hotkeys_popup.show_help, {description="show help", group="awesome"}),
	awful.key({ }, "F12",      function () quake:toggle() end, {description="dropdown terminal", group="awesome"}),

	-- Prompts
	awful.key({ modkey }, "r",
		function () awful.spawn(apps.cmd.dmenu ..
			" -nb '" ..  beautiful.bg_normal .. "' -nf '" .. beautiful.fg_normal .. "'" ..
			" -sb '" .. beautiful.bg_focus .. "' -sf '" .. beautiful.fg_focus .. "'")
		end, {description="run command", group="prompts"}),
	awful.key({ modkey, altkey, "Control" }, "r",
		function ()
			awful.prompt.run({prompt = "Run Lua code: "}, awful.screen.focused().mypromptbox.widget, awful.util.eval, nil, awful.util.getdir("cache") .. "/history_eval")
		end, {description="run lua code", group="prompts"}),

	-- Screen handling
	awful.key({ modkey, "Control" }, "[" , function () awful.screen.focus_relative(-1) end, {description="focus previous", group="screen handling"}),
	awful.key({ modkey, "Control" }, "]" , function () awful.screen.focus_relative( 1) end, {description="focus next", group="screen handling"}),

	-- Tag browsing
	awful.key({ modkey }, "\\", awful.tag.history.restore, {description="select last", group="tag handling"}),
	awful.key({ modkey, altkey }, "[" , awful.tag.viewprev, {description="select previous", group="tag handling"}),
	awful.key({ modkey, altkey }, "]" , awful.tag.viewnext, {description="select next", group="tag handling"}),
	awful.key({ modkey, altkey }, "n", function () lain.util.add_tag() end, {description="new", group="tag handling"}),
	awful.key({ modkey, altkey }, "r", function () lain.util.rename_tag() end, {description="rename", group="tag handling"}),
	awful.key({ modkey, altkey }, "d", function () lain.util.delete_tag() end, {description="delete", group="tag handling"}),
	awful.key({ modkey, altkey, "Shift" }, "[", function () lain.util.move_tag(-1) end, {description="move left", group="tag handling"}),
	awful.key({ modkey, altkey, "Shift" }, "]", function () lain.util.move_tag(1) end, {description="move right", group="tag handling"}),
	awful.key({ modkey, altkey }, "l", function () move_tag_to_screen("right") end, {description="move to screen right", group="tag handling"}),
	awful.key({ modkey, altkey }, "h", function () move_tag_to_screen("left") end, {description="move to screen left", group="tag handling"}),
	awful.key({ modkey, altkey }, "j", function () move_tag_to_screen("down") end, {description="move to screen down", group="tag handling"}),
	awful.key({ modkey, altkey }, "k", function () move_tag_to_screen("up") end, {description="move to screen up", group="tag handling"}),

	-- Default client focus
	awful.key({ altkey }, "Tab",
		function ()
			awful.client.focus.history.previous ()
			if client.focus then client.focus:raise() end
		end, {description="select previous", group="client handling"}),
	awful.key({ modkey }, "Tab",
		function ()
			awful.client.focus.byidx(1)
			if client.focus then client.focus:raise() end
		end, {description="select next", group="client handling"}),
	awful.key({ modkey , "Shift"}, "Tab",
		function ()
			awful.client.focus.byidx(-1)
			if client.focus then client.focus:raise() end
		end, {description="select previous", group="client handling"}),

	-- By direction client focus
	awful.key({ modkey }, "j",
		function()
			awful.client.focus.global_bydirection("down")
			if client.focus then client.focus:raise() end
		end, {description="select by direction, down", group="client handling"}),
	awful.key({ modkey }, "k",
		function()
			awful.client.focus.global_bydirection("up")
			if client.focus then client.focus:raise() end
		end, {description="select by direction, up", group="client handling"}),
	awful.key({ modkey }, "h",
		function()
			awful.client.focus.global_bydirection("left")
			if client.focus then client.focus:raise() end
		end, {description="select by direction, left", group="client handling"}),
	awful.key({ modkey }, "l",
		function()
			awful.client.focus.global_bydirection("right")
			if client.focus then client.focus:raise() end
		end, {description="select by direction, right", group="client handling"}),

	-- Other client handling
	awful.key({ modkey, "Control" }, "n",      awful.client.restore, {description="restore", group="client modifiers"}),
	awful.key({ modkey,           }, "u",      awful.client.urgent.jumpto, {description="jump to urgent", group="client handling"}),
	awful.key({ modkey, "Shift"   }, "k",      function () awful.client.swap.byidx( -1) end, {description="move to previous", group="client handling"}),
	awful.key({ modkey, "Shift"   }, "j",      function () awful.client.swap.byidx(  1) end, {description="move to next", group="client handling"}),

	-- Layout manipulation
	-- awful.key({ altkey, "Shift"   }, "h",      function () awful.tag.incmwfact(-0.05) end, {description="decrease mwfact", group="layout handling"}),
	-- awful.key({ altkey, "Shift"   }, "l",      function () awful.tag.incmwfact( 0.05) end, {description="increase mwfact", group="layout handling"}),
	awful.key({ modkey, "Shift"   }, "l",      function () awful.tag.incnmaster(-1) end, {description="decrease nmaster", group="layout handling"}),
	awful.key({ modkey, "Shift"   }, "h",      function () awful.tag.incnmaster( 1) end, {description="increase nmaster", group="layout handling"}),
	awful.key({ modkey, "Control" }, "l",      function () awful.tag.incncol(-1) end, {description="decrease ncol", group="layout handling"}),
	awful.key({ modkey, "Control" }, "h",      function () awful.tag.incncol( 1) end, {description="increase ncol", group="layout handling"}),
	awful.key({ modkey, "Control" }, "space",  function () awful.layout.inc(layouts,  1)  end, {description="select next", group="layout handling"}),
	awful.key({ modkey, "Shift", "Control"  }, "space",  function () awful.layout.inc(layouts, -1)  end, {description="select previous", group="layout handling"}),

	-- User programs
	awful.key({ modkey,           }, "Return", function () awful.spawn(apps.term.tmux) end, {description="terminal with tmux", group="programs"}),
	awful.key({ modkey, "Shift"   }, "Return", function () awful.spawn(apps.cmd.terminal) end, {description="terminal without tmux", group="programs"}),
	awful.key({ },                   "XF86Calculator", function () awful.spawn(apps.cmd.calculator) end, {description="calculator", group="programs"}),
	awful.key({ "Control" },         "Escape", function () awful.spawn(apps.term.procmon) end, {description="process monitor", group="programs"}),
	awful.key({ },                   "Print", function () awful.spawn(apps.cmd.screenshot) end, {description="screenshot", group="programs"}),
	awful.key({ modkey            }, "Escape", function () awful.spawn("xkill") end, {description="xkill", group="programs"}),
	awful.key({ modkey, altkey    }, "j", function () awful.spawn(apps.cmd.jira) end, {description="jira work logger", group="programs"}),

	-- Lock and shutdown
	awful.key({ modkey, "Control"          }, "l",      function () awful.spawn(apps.cmd.lock) end, {description="lock", group="session"}),
	awful.key({ altkey, "Control", "Shift" }, "Prior", function () awful.spawn(apps.cmd.reboot) end, {description="reboot", group="session"}),
	awful.key({ altkey, "Control", "Shift" }, "Next", function () awful.spawn(apps.cmd.shutdown) end, {description="shutdown", group="session"}),
	awful.key({ altkey, "Control", "Shift" }, "End", function () awful.spawn.with_shell(apps.cmd.suspend) end, {description="suspend", group="session"}),

	-- ALSA control
	awful.key({ }, "XF86AudioRaiseVolume", function () awful.spawn(apps.cmd.volume_inc) end, {description="increase volume", group="alsa"}),
	awful.key({ }, "XF86AudioLowerVolume", function () awful.spawn(apps.cmd.volume_dec) end, {description="decrease volume", group="alsa"}),
	awful.key({ }, "XF86AudioMute", function () awful.spawn(apps.cmd.volume_mute) end, {description="mute / unmute", group="alsa"}),

	-- Spotify control
	awful.key({ }, "XF86AudioPlay", function () awful.spawn.with_shell(apps.cmd.music_play) end, {description="play / pause", group="spotify"}),
	awful.key({ }, "XF86AudioStop", function () awful.spawn.with_shell(apps.cmd.music_stop) end, {description="stop", group="spotify"}),
	awful.key({ }, "XF86AudioPrev", function () awful.spawn.with_shell(apps.cmd.music_prev) end, {description="previous", group="spotify"}),
	awful.key({ }, "XF86AudioNext", function () awful.spawn.with_shell(apps.cmd.music_next) end, {description="next", group="spotify"}),
	awful.key({ }, "XF86HomePage", function () awful.spawn.with_shell(apps.cmd.music_prev) end, {description="previous", group="spotify"}),
	awful.key({ }, "XF86Mail", function () awful.spawn.with_shell(apps.cmd.music_next) end, {description="next", group="spotify"})
)

-- Xrandr setups
for i = 1, 9 do
	globalKeys = awful.util.table.join(globalKeys,
		awful.key({ modkey, "Control" }, "F" .. i , function ()
			awful.spawn(apps.cmd.xrandr_setup .. " " .. i)
		end, {description="switch to xrandr setup", group="screen handling"}))
end

-- Tag manipulation
for i = 1, 9 do
	globalKeys = awful.util.table.join(globalKeys,
		awful.key({ modkey            }, "#" .. i + 9,
			function ()
				local screen = awful.screen.focused()
				local tag = screen.tags[i]
				if tag then
					tag:view_only()
				end
			end, {description="select tag", group="tag handling"}),
		awful.key({ modkey, "Control" }, "#" .. i + 9,
			function ()
				local screen = awful.screen.focused()
				local tag = screen.tags[i]
				if tag then
					awful.tag.viewtoggle(tag)
				end
			end, {description="toggle tag", group="tag handling"}),
		awful.key({ modkey, "Shift"   }, "#" .. i + 9,
			function ()
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:move_to_tag(tag)
					tag:view_only()
				end
			end, {description="move to tag", group="client handling"}),
		awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
			function ()
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:toggle_tag(tag)
				end
			end, {description="toggle tag", group="client handling"}))
end

return {
	rootButtons = rootButtons,
	layoutButtons = layoutButtons,
	taglistButtons = taglistButtons,
	tasklistButtons = tasklistButtons,
	clientKeys = clientKeys,
	clientButtons = clientButtons,
	getTitlebarButtons = getTitlebarButtons,
	globalKeys = globalKeys,
}

