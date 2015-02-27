local awful = require("awful")
local tyrannical = require("tyrannical")


tyrannical.settings.block_children_focus_stealing = true
tyrannical.settings.group_children = true

tyrannical.settings.tag.layout = awful.layout.suit.tile
tyrannical.settings.tag.mwfact = 0.6


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
			"Firefox",
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
		}
	},
	{
		name        = "dev",
		init        = true,
		exclusive   = false,
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
		name        = "chat",
		init        = true,
		position    = 3,
		exclusive   = false,
		screen      = config.scr.sec,
		force_screen= true,
		layout      = awful.layout.suit.tile.left,
		class       = {
			"Skype",
			"Skype-bin",
		}
	},
	{
		name        = "irc",
		init        = true,
		position    = 3,
		exclusive   = false,
		screen      = config.scr.sec,
		force_screen= true,
		layout      = awful.layout.suit.tile.left,
		class       = {
			"Konversation",
			"weechat",
			"irssi",
		}
	},
	{
		name        = "music",
		init        = true,
		position    = 4,
		exclusive   = true,
		screen      = config.scr.sec,
		force_screen= true,
		layout      = awful.layout.suit.tile.left,
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
		layout      = awful.layout.suit.max,
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
		}
	},
}

tyrannical.properties.intrusive = {
	"ksnapshot",
	"kcalc",
	"Qalculate-gtk",
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
	"kmix",
	"kcalc",
	"Qalculate-gtk",
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
	"xephyr",
	"ksnapshot",
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

tyrannical.properties.centered = {
	"kcalc",
	"qalculate-gtk",
}

tyrannical.properties.skip_taskbar = {
	"yakuake",
}

tyrannical.properties.hidden = {
	"yakuake",
}

tyrannical.properties.size_hints_honor = {
	["xterm"] = false,
	["urxvt"] = false,
	"krusader",
	["spotify"] = false,
}

