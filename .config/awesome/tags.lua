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
			"Opera",
			"Opera developer",
			"Firefox",
			"google-chrome",
			"google-chrome-beta",
			"google-chrome-unstable",
			"Rekonq",
			"Dillo",
			"Arora",
			"Chromium",
			"nightly",
			"Nightly",
			"minefield",
			"Minefield",
			"luakit",
		}
	},
	{
		name        = "files",
		init        = true,
		exclusive   = false,
		screen      = config.scr.pri,
		layout      = awful.layout.suit.tile.top,
		class  = {
			"Thunar",
			"Konqueror",
			"Dolphin",
			"ark",
			"Nautilus",
			"Krusader",
			"urxvt:files",
		}
	},
	{
		name        = "dev",
		init        = true,
		exclusive   = false,
		selected    = true,
		screen      = config.scr.pri,
		layout      = awful.layout.suit.tile.left,
		class = {
			"Kate",
			"KDevelop",
			"Codeblocks",
			"Code::Blocks",
			"DDD",
			"kate4",
		}
	},
	{
		name        = "www",
		init        = config.scr.pri ~= config.scr.sec,
		selected    = true,
		position    = 3,
		exclusive   = false,
		screen      = config.scr.sec,
		force_screen= true,
		layout      = awful.layout.suit.tile.left,
		class       = {}
	},
	{
		name        = "music",
		init        = true,
		position    = 4,
		exclusive   = true,
		screen      = config.scr.sec,
		force_screen= true,
		layout      = awful.layout.suit.tile.left,
		exec_once   = {"spotify"},
		class       = {
			"Amarok",
			"spotify",
		}
	},
	-- Any screen
	{
		name        = "doc",
		init        = false,
		volatile    = true,
		exclusive   = true,
		layout      = awful.layout.suit.tile.right,
		class       = {
			"Okular",
			"Xpdf",
			"OOWriter",
			"OOCalc",
			"OOMath",
			"OOImpress",
			"OOBase",
			"openoffice.org",
			"OpenOffice.*",
			"gimp",
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
	-- "urxvt",
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
	"bcompare",
}

tyrannical.properties.maximized_vertical = {
	"bcompare",
}

tyrannical.properties.size_hints_honor = {
	["xterm"] = false,
	["urxvt"] = false,
	["spotify"] = false,
}

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

