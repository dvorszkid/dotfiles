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
	awful.button({        }, 1, awful.tag.viewonly),
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
	awful.key({ modkey,  altkey   }, "f"     , function (c) c.fullscreen = not c.fullscreen end),
	awful.key({ modkey, "Control" }, "c"     , function (c) c:kill() end),
	awful.key({ modkey,           }, "f"     , awful.client.floating.toggle),
	awful.key({ modkey,           }, "o"     , function (c) c:move_to_screen() end),
	awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
	awful.key({ modkey,           }, "t"     , function (c) c.ontop = not c.ontop end),
	awful.key({ modkey,  altkey   }, "t"     , awful.titlebar.toggle),
	awful.key({ modkey,           }, "s"     , function (c) c.sticky = not c.sticky end),
	awful.key({ modkey,           }, "n"     , function (c) c.minimized = true end),
	awful.key({ modkey,           }, "m"     , function (c)
		c.maximized_horizontal = not c.maximized_horizontal
		c.maximized_vertical   = not c.maximized_vertical
	end)
)

-- Client buttons
local clientButtons = awful.util.table.join(
	awful.button({        }, 1, function (c) client.focus = c; c:raise() end),
	awful.button({ modkey }, 1, awful.mouse.client.move),
	awful.button({ modkey }, 3, awful.mouse.client.resize)
)

-- Titlebar buttons
local titlebarButtons = awful.util.table.join(
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

-- Dropdown terminal
local quake = lain.util.quake({
	app = "urxvtc",
	extra = "-e " .. apps.cmd.tmux_session .. "dropdown",
	onlyone = true,
	followtag = true,
	height = 0.7,
})

-- Global keys
local globalKeys = awful.util.table.join(
	awful.key({ modkey, "Control" }, "h" , hotkeys_popup.show_help),
	awful.key({ modkey, "Control" }, "[" , function () awful.screen.focus_relative(-1) end),
	awful.key({ modkey, "Control" }, "]" , function () awful.screen.focus_relative( 1) end),

	-- Tag browsing
	awful.key({ modkey }, "\\", awful.tag.history.restore),
	awful.key({ modkey, altkey }, "[" , awful.tag.viewprev),
	awful.key({ modkey, altkey }, "]" , awful.tag.viewnext),
	awful.key({ modkey, altkey }, "n", function () lain.util.add_tag() end),
	awful.key({ modkey, altkey }, "r", function () lain.util.rename_tag() end),
	awful.key({ modkey, altkey }, "d", function () lain.util.delete_tag() end),
	awful.key({ modkey, altkey, "Shift" }, "[", function () lain.util.move_tag(-1) end),
	awful.key({ modkey, altkey, "Shift" }, "]", function () lain.util.move_tag(1) end),

	awful.key({ modkey         }, "Escape", function () awful.util.spawn("xkill") end),

	-- Default client focus
	awful.key({ altkey }, "Tab",
		function ()
			awful.client.focus.history.previous ()
			if client.focus then client.focus:raise() end
		end),
	awful.key({ modkey }, "Tab",
		function ()
			awful.client.focus.byidx(1)
			if client.focus then client.focus:raise() end
		end),
	awful.key({ modkey , "Shift"}, "Tab",
		function ()
			awful.client.focus.byidx(-1)
			if client.focus then client.focus:raise() end
		end),

	-- By direction client focus
	awful.key({ modkey }, "j",
		function()
			awful.client.focus.global_bydirection("down")
			if client.focus then client.focus:raise() end
		end),
	awful.key({ modkey }, "k",
		function()
			awful.client.focus.global_bydirection("up")
			if client.focus then client.focus:raise() end
		end),
	awful.key({ modkey }, "h",
		function()
			awful.client.focus.global_bydirection("left")
			if client.focus then client.focus:raise() end
		end),
	awful.key({ modkey }, "l",
		function()
			awful.client.focus.global_bydirection("right")
			if client.focus then client.focus:raise() end
		end),

	-- Layout manipulation
	awful.key({ modkey, "Shift"   }, "j",      function () awful.client.swap.byidx(  1) end),
	awful.key({ modkey, "Shift"   }, "k",      function () awful.client.swap.byidx( -1) end),
	awful.key({ modkey,           }, "u",      awful.client.urgent.jumpto),
	awful.key({ altkey, "Shift"   }, "l",      function () awful.tag.incmwfact( 0.05) end),
	awful.key({ altkey, "Shift"   }, "h",      function () awful.tag.incmwfact(-0.05) end),
	awful.key({ modkey, "Shift"   }, "l",      function () awful.tag.incnmaster(-1) end),
	awful.key({ modkey, "Shift"   }, "h",      function () awful.tag.incnmaster( 1) end),
	awful.key({ modkey, "Control" }, "l",      function () awful.tag.incncol(-1) end),
	awful.key({ modkey, "Control" }, "h",      function () awful.tag.incncol( 1) end),
	awful.key({ modkey, "Control" }, "n",      awful.client.restore),
	awful.key({ modkey, "Control" }, "space",  function () awful.layout.inc(layouts,  1)  end),
	awful.key({ modkey, "Shift", "Control"  }, "space",  function () awful.layout.inc(layouts, -1)  end),

	-- User programs
	awful.key({ modkey,           }, "Return", function () awful.util.spawn(apps.term.tmux) end),
	awful.key({ modkey, "Shift"   }, "Return", function () awful.util.spawn(apps.cmd.terminal) end),
	awful.key({ },                   "XF86Calculator", function () awful.util.spawn(apps.cmd.calculator) end),
	awful.key({ "Control" },         "Escape", function () awful.util.spawn(apps.term.procmon) end),
	awful.key({ },                   "Print", function () awful.util.spawn(apps.cmd.screenshot) end),

	-- Prompts
	awful.key({ modkey }, "r",
		function () awful.util.spawn(apps.cmd.dmenu ..
			" -nb '" ..  beautiful.bg_normal .. "' -nf '" .. beautiful.fg_normal .. "'" ..
			" -sb '" .. beautiful.bg_focus .. "' -sf '" .. beautiful.fg_focus .. "'")
		end),
	awful.key({ modkey, altkey, "Control" }, "r",
		function ()
			awful.prompt.run({prompt = "Run Lua code: "}, awful.screen.focused().mypromptbox.widget, awful.util.eval, nil, awful.util.getdir("cache") .. "/history_eval")
		end
	),

	-- Dropdown terminal
	awful.key({ }, "F12",      function () quake:toggle() end),

	-- Lock and shutdown
	awful.key({ modkey, "Control"          }, "l",      function () awful.util.spawn(apps.cmd.lock) end),
	awful.key({ altkey, "Control", "Shift" }, "Prior", function () awful.util.spawn(apps.cmd.reboot) end),
	awful.key({ altkey, "Control", "Shift" }, "Next", function () awful.util.spawn(apps.cmd.shutdown) end),
	awful.key({ altkey, "Control", "Shift" }, "End", function () awful.util.spawn_with_shell(apps.cmd.suspend) end),

	-- Awesome control
	awful.key({ modkey, "Control" }, "r",      awesome.restart),
	awful.key({ modkey, "Control" }, "q",      awesome.quit),

	-- ALSA control
	awful.key({ }, "XF86AudioRaiseVolume", function () awful.spawn(apps.cmd.volume_inc) end),
	awful.key({ }, "XF86AudioLowerVolume", function () awful.spawn(apps.cmd.volume_dec) end),
	awful.key({ }, "XF86AudioMute", function () awful.spawn(apps.cmd.volume_mute) end),

	-- Spotify control
	awful.key({ }, "XF86AudioPlay", function () awful.util.spawn_with_shell(apps.cmd.music_play) end),
	awful.key({ }, "XF86AudioStop", function () awful.util.spawn_with_shell(apps.cmd.music_stop) end),
	awful.key({ }, "XF86AudioNext", function () awful.util.spawn_with_shell(apps.cmd.music_next) end),
	awful.key({ }, "XF86AudioPrev", function () awful.util.spawn_with_shell(apps.cmd.music_prev) end),
	awful.key({ }, "XF86HomePage", function () awful.util.spawn_with_shell(apps.cmd.music_prev) end),
	awful.key({ }, "XF86Mail", function () awful.util.spawn_with_shell(apps.cmd.music_next) end)
)

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
			end),
		awful.key({ modkey, "Control" }, "#" .. i + 9,
			function ()
				local screen = awful.screen.focused()
				local tag = screen.tags[i]
				if tag then
					awful.tag.viewtoggle(tag)
				end
			end),
		awful.key({ modkey, "Shift"   }, "#" .. i + 9,
			function ()
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end),
		awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
			function ()
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:toggle_tag(tag)
				end
			end))
end

return {
	rootButtons = rootButtons,
	layoutButtons = layoutButtons,
	taglistButtons = taglistButtons,
	tasklistButtons = tasklistButtons,
	clientKeys = clientKeys,
	clientButtons = clientButtons,
	titlebarButtons = titlebarButtons,
	globalKeys = globalKeys,
}

