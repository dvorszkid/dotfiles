local awful        = require("awful")
local beautiful    = require("beautiful")
local tools        = require("tools")
local drop         = require("scratch.drop")
local apps         = require("apps")

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

-- Taglist buttons
local taglistButtons = awful.util.table.join(
	awful.button({        }, 1, awful.tag.viewonly),
	awful.button({        }, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 1, awful.client.movetotag),
	awful.button({ modkey }, 3, awful.client.toggletag),
	awful.button({        }, 4, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end),
	awful.button({        }, 5, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end)
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
				if not c:isvisible() then
					awful.tag.viewonly(c:tags()[1])
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
	awful.key({ modkey,           }, "f"     , function (c) c.fullscreen = not c.fullscreen end),
	awful.key({ modkey, "Control" }, "c"     , function (c) c:kill() end),
	awful.key({ modkey,           }, "space" , awful.client.floating.toggle),
	awful.key({ modkey,           }, "o"     , awful.client.movetoscreen),
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

-- Global keys
local globalKeys = awful.util.table.join(
	awful.key({ modkey, "Control" }, "[" , function () awful.screen.focus_relative(-1) end),
	awful.key({ modkey, "Control" }, "]" , function () awful.screen.focus_relative( 1) end),

	-- Tag browsing
	awful.key({ modkey, altkey }, "[" , awful.tag.viewprev),
	awful.key({ modkey, altkey }, "]" , awful.tag.viewnext),
	awful.key({ modkey }, "\\", awful.tag.history.restore),

	awful.key({  "Control"         }, "Escape", function () awful.util.spawn("xkill") end),

	-- Default client focus
	awful.key({ altkey }, "Tab",
		function ()
			awful.client.focus.byidx(1)
			if client.focus then client.focus:raise() end
		end),
	awful.key({ altkey , "Shift"}, "Tab",
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
	-- awful.key({ modkey, "Control" }, "space",  function () awful.layout.inc(layouts,  1)  end),
	-- awful.key({ modkey, "Shift", "Control"  }, "space",  function () awful.layout.inc(layouts, -1)  end),

	-- User programs
	awful.key({ modkey,           }, "Return", function () awful.util.spawn(apps.term.tmux) end),
	awful.key({ modkey, "Shift"   }, "Return", function () awful.util.spawn(apps.cmd.terminal) end),
	awful.key({ modkey, altkey }, "b", function () tools.run_or_raise(apps.cmd.browser, { class = "Firefox" }) end),
	awful.key({ modkey, altkey }, "f", function () tools.run_or_raise(apps.cmd.filemanager, { name = "Krusader" }) end),
	awful.key({ modkey, altkey }, "s", function () tools.run_or_raise(apps.cmd.music, { class = "Spotify" }) end),
	awful.key({ modkey, altkey }, "i", function () tools.run_or_raise(apps.tmux.irc, { name = "WeeChat" }) end),
	awful.key({ modkey, altkey }, "c", function () awful.util.spawn(apps.cmd.calculator) end),
	awful.key({ modkey, altkey }, "h", function () awful.util.spawn(apps.term.procmon) end),

	-- Prompt
	awful.key({ modkey }, "d",
		function () awful.util.spawn(apps.cmd.dmenu ..
			" -nb '" ..  beautiful.bg_normal .. "' -nf '" .. beautiful.fg_normal .. "'" ..
			" -sb '" .. beautiful.bg_focus .. "' -sf '" .. beautiful.fg_focus .. "'")
		end),
	awful.key({ modkey }, "r",
		function ()
			awful.prompt.run({ prompt = "Run: ", hooks = {
				{{         },"Return",function(command)
					local result = awful.util.spawn(command)
					mypromptbox[mouse.screen].widget:set_text(type(result) == "string" and result or "")
					return true
				end},
				{{altkey   },"Return",function(command)
					local result = awful.util.spawn(command,{intrusive=true})
					mypromptbox[mouse.screen].widget:set_text(type(result) == "string" and result or "")
					return true
				end},
				{{"Shift"  },"Return",function(command)
					local result = awful.util.spawn(command,{intrusive=true,ontop=true,floating=true})
					mypromptbox[mouse.screen].widget:set_text(type(result) == "string" and result or "")
					return true
				end}
			}},
			mypromptbox[mouse.screen].widget,
			function (com)
					local result = awful.util.spawn(com)
					if type(result) == "string" then
						mypromptbox[mouse.screen].widget:set_text(result)
					end
					return true
			end, awful.completion.shell,
			awful.util.getdir("cache") .. "/history")
		end
	),
	awful.key({ modkey, "Shift" }, "r",
		function ()
			awful.prompt.run({prompt = "Run Lua code: "}, mypromptbox[mouse.screen].widget, awful.util.eval, nil, awful.util.getdir("cache") .. "/history_eval")
		end
	),

	-- Dropdown terminal
	awful.key({                            }, "F12",      function () drop(apps.term.tmux_session .. "dropdown", top, center, 0.9, 0.75, true, config.scr.pri) end),

	-- Lock and shutdown
	awful.key({ modkey, "Control"          }, "l",      function () awful.util.spawn(apps.cmd.lock) end),
	awful.key({ altkey, "Control", "Shift" }, "Prior", function () awful.util.spawn(apps.cmd.reboot) end),
	awful.key({ altkey, "Control", "Shift" }, "Next", function () awful.util.spawn(apps.cmd.shutdown) end),
	awful.key({ altkey, "Control", "Shift" }, "End", function () awful.util.spawn_with_shell(apps.cmd.suspend) end),

	-- Awesome control
	awful.key({ modkey, "Control" }, "r",      awesome.restart),
	awful.key({ modkey, "Control" }, "q",      awesome.quit),

	-- ALSA volume control
	awful.key({ }, "XF86AudioRaiseVolume", function ()
		awful.util.spawn(apps.cmd.volume_inc)
		if (volume ~= nil) then
			volume.update()
		end
	end),
	awful.key({ }, "XF86AudioLowerVolume", function ()
		awful.util.spawn(apps.cmd.volume_dec)
		if (volume ~= nil) then
			volume.update()
		end
	end),
	awful.key({ }, "XF86AudioMute",        function ()
		awful.util.spawn(apps.cmd.volume_mute)
		if (volume ~= nil) then
			volume.update()
		end
	end),

	-- Spotify control
	awful.key({ }, "XF86AudioPlay", function () awful.util.spawn_with_shell(apps.cmd.music_play) end),
	awful.key({ }, "XF86AudioStop", function () awful.util.spawn_with_shell(apps.cmd.music_stop) end),
	awful.key({ }, "XF86AudioNext", function () awful.util.spawn_with_shell(apps.cmd.music_next) end),
	awful.key({ }, "XF86AudioPrev", function () awful.util.spawn_with_shell(apps.cmd.music_prev) end)
)

-- Tag manipulation
for i = 1, 9 do
	globalKeys = awful.util.table.join(globalKeys,
		awful.key({ modkey            }, "#" .. i + 9,
			function ()
				local tag = awful.tag.gettags(mouse.screen)[i]
				if tag then
					awful.tag.viewonly(tag)
				end
			end),
		awful.key({ modkey, "Control" }, "#" .. i + 9,
			function ()
				local tag = awful.tag.gettags(mouse.screen)[i]
				if tag then
					awful.tag.viewtoggle(tag)
				end
			end),
		awful.key({ modkey, "Shift"   }, "#" .. i + 9,
			function ()
				local tag = awful.tag.gettags(client.focus.screen)[i]
				if client.focus and tag then
					awful.client.movetotag(tag)
				end
			end),
		awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
			function ()
				local tag = awful.tag.gettags(client.focus.screen)[i]
				if client.focus and tag then
					awful.client.toggletag(tag)
				end
			end))
end

return {
	rootButtons = rootButtons,
	taglistButtons = taglistButtons,
	tasklistButtons = tasklistButtons,
	clientKeys = clientKeys,
	clientButtons = clientButtons,
	titlebarButtons = titlebarButtons,
	globalKeys = globalKeys,
}

