local awful = require("awful")
local tyrannical = require("tyrannical")
local gears = require("gears")

tyrannical.settings.block_children_focus_stealing = true
tyrannical.settings.group_children = true
tyrannical.settings.force_odd_as_intrusive = true

tyrannical.settings.tag.layout = awful.layout.suit.tile
tyrannical.settings.tag.master_width_factor = 0.6

tyrannical.tags = {
    {
        name = "www",
        init = true,
        exclusive = true,
        screen = config.scr.pri,
        layout = awful.layout.suit.max,
        class = {
            "brave-browser",
            "opera",
            "firefox",
            "navigator",
            "google-chrome",
            "google-chrome-beta",
            "google-chrome-unstable",
        },
    },
    {
        name = "dev",
        init = true,
        exclusive = true,
        selected = true,
        screen = config.scr.pri,
        layout = awful.layout.suit.max,
        class = {},
    },
    {
        name = "music",
        init = true,
        position = 1,
        exclusive = true,
        screen = config.scr.sec,
        force_screen = true,
        layout = awful.layout.suit.tile.left,
        class = {
            "amarok",
            "spotify",
        },
    },
    {
        name = "video",
        init = false,
        volatile = true,
        exclusive = true,
        -- TODO: depend on dynamic screen config
        --screen      = config.scr.sec,
        --force_screen= true,
        layout = awful.layout.suit.tile.left,
        class = {
            "mplayer",
            "mpv",
            "smplayer",
            "vlc",
        },
    },
    {
        name = "doc",
        init = false,
        volatile = true,
        exclusive = true,
        screen = config.scr.sec,
        force_screen = true,
        layout = awful.layout.suit.max,
        class = {
            "okular",
            "libreoffice",
            "libreoffice-writer",
            "libreoffice-calc",
            "libreoffice-impress",
            "Soffice",
            "gimp",
            "nomacs",
            "image lounge",
        },
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
    "kitty-quick-access",
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

tyrannical.properties.placement = {}

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

-- Hack for making Firefox not floating
-- (somehow it is always floating by default)
local browser_fix = function(c)
    if
        (c.class == "Firefox" or string.find(c.class, "chrom") or string.find(c.class, "brave"))
        and c.role == "browser"
    then
        c.floating = false
        c.maximized = false -- better screen resize handling
        awful.titlebar.hide(c)
    end
end
client.connect_signal("manage", browser_fix)
client.connect_signal("property::class", browser_fix)

-- Hack for making kitty quick access kitten appear on current tag
local kitty_quick_access_fix = function(c)
    if c.class == "kitty-quick-access" then
        c:move_to_tag(awful.screen.focused().selected_tag)
    end
end
client.connect_signal("property::class", kitty_quick_access_fix)
