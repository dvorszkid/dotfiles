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
        name        = "www",
        init        = true,
        exclusive   = true,
        screen      = config.scr.pri,
        layout      = awful.layout.suit.max,
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
        -- TODO: depend on dynamic screen config
        --screen      = config.scr.sec,
        --force_screen= true,
        layout      = awful.layout.suit.tile.left,
        class       = {
            "mplayer",
            "mpv",
            "smplayer",
            "vlc",
        }
    },
    {
        name        = "vnc",
        init        = false,
        volatile    = true,
        layout      = awful.layout.suit.max,
        class       = {
            "vncviewer",
        }
    },
    {
        name        = "zoom",
        init        = false,
        volatile    = true,
        layout      = awful.layout.suit.max,
        screen      = config.scr.sec,
        master_width_factor = 0.2,
        class       = {
            "zoom",
        }
    },
    {
        name        = "discord",
        init        = false,
        volatile    = true,
        layout      = awful.layout.suit.tile.left,
        screen      = config.scr.sec,
        class       = {
            "discord",
        }
    },
    {
        name        = "doc",
        init        = false,
        volatile    = true,
        exclusive   = true,
        screen      = config.scr.sec,
        force_screen= true,
        layout      = awful.layout.suit.max,
        class       = {
            "okular",
            "libreoffice",
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


-- Zoom
--  * meeting should prevent screensaver
--  * floating popups
client.connect_signal("manage", function (c)
    if c.class ~=  "zoom" then
        return
    end

    -- floating popups
    c.floating = c.name == "zoom"

    -- WM_CLASS is "zoom" for both main window and meeting window
    -- WM_NAME is "Zoom" in the beginning, then it gets updated to "Zoom Meeting"
    if not (c.name == "Zoom" or c.name == "Zoom Meeting") then
        return
    end

    --print('[Zoom] Starting timer for C:' .. c.class .. ', N:' .. c.name)
    c.heartbeat_timer = gears.timer {
        timeout   = 60,
        call_now  = false,
        autostart = true,
        callback  = function()
            --print('[Zoom] Resetting screensaver')
            awful.spawn("xset s reset")
        end
    }
end)
client.connect_signal("unmanage", function (c)
    if c.heartbeat_timer == nil then
        return
    end
    --print('[Zoom] Stopping timer for C:' .. c.class .. ', N:' .. c.name)
    c.heartbeat_timer:stop()
    c.heartbeat_timer = nil
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


-- Hack for making Firefox not floating
-- (somehow it is always floating by default)
client.connect_signal("property::class", function(c)
    if (c.class == "Firefox" or string.find(c.class, "chrom")) and c.role == "browser" then
        c.floating = false
        c.maximized = false -- better screen resize handling
    end
end)


client.connect_signal("property::class", function(c)
    if c.name ~= "Tresorit Core Log Browser" then
        return
    end

    --f = awful.screen.focused()
    --awful.screen.focus(config.scr.sec)

    local tagName = 'corelogs'
    local t = awful.tag.find_by_name(awful.screen.focused(), tagName)
    if not t then
        t = awful.tag.add(tagName, {
            screen = awful.screen.focused(),
            layout = awful.layout.suit.max,
            volatile = true
        })
    end
    t:view_only()
    c:move_to_tag(t)

    --awful.screen.focus(f)
end)
