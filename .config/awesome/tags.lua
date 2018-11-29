local awful = require("awful")
local tyrannical = require("tyrannical")


tyrannical.settings.block_children_focus_stealing = true
tyrannical.settings.group_children = true

tyrannical.settings.tag.layout = awful.layout.suit.tile
tyrannical.settings.tag.master_width_factor = 0.6


tyrannical.tags = {
    {
        name        = "www",
        init        = true,
        exclusive   = true,
        screen      = config.scr.pri,
        layout      = awful.layout.suit.tile.left,
        class = {
            "firefox",
            "navigator",
            "google-chrome",
            "google-chrome-beta",
            "google-chrome-unstable",
        }
    },
    {
        name        = "dev",
        init        = true,
        exclusive   = true,
        selected    = true,
        screen      = config.scr.pri,
        layout      = awful.layout.suit.max,
        class = {
            "bcompare",
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
awful.client.property.persist("original_name", "string")
client.connect_signal("property::class", function (c)
    if c.class ~= "URxvt" or c.floating then
        return
    end
    if c.original_name == '' then
        c.original_name = c.name
    end
    -- print('[callback] C:' .. c.class .. ', N:' .. c.name .. ', ON:' .. c.original_name)

    local t = awful.tag.find_by_name(awful.screen.focused(), c.original_name)
    if not t then
        t = awful.tag.add(c.original_name, {
            screen = awful.screen.focused(),
            layout = awful.layout.suit.tile.left,
            volatile = true
        })
    end
    t:view_only()
    c:move_to_tag(t)
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

