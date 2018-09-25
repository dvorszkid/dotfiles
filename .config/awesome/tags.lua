local awful = require("awful")
local tyrannical = require("tyrannical")


tyrannical.settings.block_children_focus_stealing = true
tyrannical.settings.group_children = true

tyrannical.settings.tag.layout = awful.layout.suit.tile
tyrannical.settings.tag.master_width_factor = 0.6


tyrannical.tags = {
	-- Primary screen
	{
		name        = "www",
		init        = true,
		exclusive   = true,
		screen      = config.scr.pri,
		layout      = awful.layout.suit.tile.left,
		class = {
			"firefox",
			"google-chrome",
			"google-chrome-beta",
			"google-chrome-unstable",
		}
	},
	{
		name        = "dev",
		init        = true,
		exclusive   = false,
		selected    = true,
		screen      = config.scr.pri,
		layout      = awful.layout.suit.max,
		class = {
			"bcompare",
			"urxvt:dev",
		}
	},
	{
		name        = "music",
		init        = true,
		position    = 1,
		exclusive   = true,
		screen      = config.scr.sec,
		force_screen= true,
		layout      = awful.layout.suit.tile.left,
		exec_once   = {"spotify"},
		class       = {
			"amarok",
			"spotify",
		}
	},
	{
		name        = "video",
		init        = false,
		volatile    = true,
		exclusive   = true,
		screen      = config.scr.sec,
		force_screen= true,
		layout      = awful.layout.suit.tile.left,
		class       = {
			"mplayer",
			"mpv",
			"smplayer",
			"vlc",
		}
	},
	{
		name        = "email",
		init        = false,
		volatile    = true,
		exclusive   = true,
		layout      = awful.layout.suit.tile.left,
		class       = {
			"hiri",
		}
	},
	{
		name        = "doc",
		init        = false,
		volatile    = true,
		exclusive   = true,
		screen      = config.scr.sec,
		force_screen= true,
		layout      = awful.layout.suit.tile.left,
		class       = {
			"okular",
			"libreoffice-writer",
			"libreoffice-calc",
			"libreoffice-impress",
			"Soffice",
			"gimp",
			"nomacs",
			"image lounge",
		}
	},
}

tyrannical.properties.intrusive = {
	"ksnapshot",
	"spectacle",
	"kcalc",
	"qalculate-gtk",
	"Gradient editor",
	"About KDE",
	"Paste Special",
	"Background color",
	"kcolorchooser",
	"plasmoidviewer",
	"plasmaengineexplorer",
	"Xephyr",
	"kruler",
	"yakuake",
	"xev",
}

tyrannical.properties.floating = {
	"mplayer",
	"mplayer2",
	"smplayer",
	"ksnapshot",
	"spectacle",
	"kmix",
	"kcalc",
	"qalculate-gtk",
	"yakuake",
	"Select Color$",
	"kruler",
	"kcolorchooser",
	"New Form",
	"Insert Picture",
	"kcharselect",
	"plasmoidviewer",
	"xev",
	"conky",
}

tyrannical.properties.ontop = {
	"ksnapshot",
	"spectacle",
	"kruler",
}

tyrannical.properties.focusable = {
	["conky"] = false,
}

tyrannical.properties.no_autofocus = {
	"conky",
}

tyrannical.properties.below = {
	"conky",
}

tyrannical.properties.placement = {
	["qalculate-gtk"] = awful.placement.centered,
}

tyrannical.properties.skip_taskbar = {
	"yakuake",
}

tyrannical.properties.hidden = {
	"yakuake",
}

tyrannical.properties.maximized_horizontal = {
	-- "bcompare",
}

tyrannical.properties.maximized_vertical = {
	-- "bcompare",
}

tyrannical.properties.size_hints_honor = {
	["xterm"] = false,
	["urxvt"] = false,
	["spotify"] = false,
}


-- Make URxvt instances run on tag found by original WM_NAME
-- awful.client.property.persist("overwrite_class", "string")
-- client.connect_signal("property::class", function (c)
--	name = c.name or ''
--	if name == '' then
--		return
--	end
--	if c.class == "URxvt" and name ~= "urxvt" and c.overwrite_class == '' then
--		c.overwrite_class = c.class .. ":" .. name
--	end
-- end)
awful.client.property.persist("original_name", "string")
client.connect_signal("property::class", function (c)
	class = c.class or ''
	name = c.name or ''
	if c.original_name ~= '' then
		name = c.original_name
	end
	if c.class == "URxvt" and name ~= "urxvt" then
		local t = awful.tag.find_by_name(awful.screen.focused(), name)
		if t then
			c.original_name = name
			c:move_to_tag(t)
		end
	end
end)


-- Hack for making Spotify run on 'music' tag
-- (it sets the WM_CLASS property after displaying the application window)
client.connect_signal("property::class", function(c)
	if c.class == "Spotify" then
		local t = awful.tag.find_by_name(awful.screen.focused(), "music")
		if t then
			c:move_to_tag(t)
		end
	end
end)

