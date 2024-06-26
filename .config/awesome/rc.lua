-- {{{ Required libraries
-- Standard awesome libraries
local gears      = require("gears")
local awful      = require("awful")
awful.rules      = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox      = require("wibox")
-- Theme handling library
local beautiful  = require("beautiful")
-- Notification library
local naughty    = require("naughty")
-- Plugins
local lain       = require("lain")
local tyrannical = require("tyrannical")
-- Configs
local autostart  = require("autostart")
-- }}}


-- {{{ Error handling
-- Handle startup errors
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "AwesomeWM: startup_errors",
        text = awesome.startup_errors
    })
end


-- Autostart
for _, cmd in pairs(autostart) do
    awful.spawn.with_shell("pgrep -u $USER -f \"" .. cmd .. "\"$ || (sleep 1 && " .. cmd .. ")")
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
                title = "AwesomeWM: debug::error signal",
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
modkey      = "Mod4"
altkey      = "Mod1"
hostname    = io.popen("uname -n"):read()
user        = os.getenv("USER")
home_dir    = os.getenv("HOME")
conf_dir    = awful.util.getdir("config")

config = {}
config.dpi_scaling   = screen.primary.dpi / 96
config.titlebars     = true
config.sloppyFocus   = true
config.scr           = {
    pri = 1,
    sec = screen.count() > 1 and 2 or 1,
}
config.wallpaperPath = home_dir .. "/.local/share/wallpapers/"
naughty.config.defaults.screen = config.scr.pri
naughty.config.defaults.position = "bottom_right"
naughty.config.presets.system = {
    title = "AwesomeWM",
    position = "top_right",
}

-- lain
lain.layout.termfair.nmaster   = 3
lain.layout.termfair.ncol      = 1
lain.layout.termfair.center.nmaster = 3
lain.layout.termfair.center.ncol    = 1

-- layout setup
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.fair,
    awful.layout.suit.tile.left,
    awful.layout.suit.max,
}

-- tyrannical init
dofile(conf_dir .. "/tags.lua")

-- beautiful init
beautiful.init(conf_dir .. "/theme.lua")
local titlebars_enabled = beautiful.titlebar_enabled == nil and (config.titlebars == true) or beautiful.titlebar_enabled

-- ui init
local ui  = require("ui")

-- wallpaper
local function set_wallpaper(s)
    local wallpaper = config.wallpaperPath .. s.index
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)
end

-- re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)
-- }}}

-- {{{ Wibox
local keys  = require("keys")
keys.setupUi(ui)

awful.util.taglist_buttons = keys.taglistButtons
awful.util.tasklist_buttons = keys.tasklistButtons
awful.util.layoutbox_buttons = keys.layoutButtons

-- Screen widgets
awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Custom taglist func
    s.mytaglist_func = function (w, buttons, label, data, tags)
        local function mylabel(c)
            local text, bg_color, bg_image, icon, other_args = label(c)
            text = text:gsub(">" .. c.name .. "<", ">" .. c.index .. ": " .. c.name .. "<")
            return text:lower(), bg_color, bg_image, icon, other_args
        end
        return awful.widget.common.list_update(w, buttons, mylabel, data, tags)
    end

    ui.at_screen_connect(s)
end)
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
                     raise = true,
                     keys = keys.clientKeys,
                     buttons = keys.clientButtons,
                     screen = awful.screen.preferred,
                     size_hints_honor = false,
                     placement = awful.placement.no_overlap+awful.placement.under_mouse+awful.placement.no_offscreen }
    },

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" } },
      properties = { titlebars_enabled = true }
    },
}
-- }}}


-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
        awful.placement.no_overlap(c)
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

client.connect_signal("request::titlebars", function(c)
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        awful.titlebar(c, {
            size = 18*config.dpi_scaling
        }):setup {
            -- Left
            {
                awful.titlebar.widget.iconwidget(c),
                awful.titlebar.widget.stickybutton(c),
                awful.titlebar.widget.ontopbutton(c),
                buttons = buttons,
                layout  = wibox.layout.fixed.horizontal
            },
            -- Middle
            {
                { -- Title
                    align  = "center",
                    widget = awful.titlebar.widget.titlewidget(c)
                },
                buttons = keys.getTitlebarButtons(c),
                layout  = wibox.layout.flex.horizontal
            },
            -- Right
            {
                awful.titlebar.widget.floatingbutton(c),
                awful.titlebar.widget.maximizedbutton(c),
                awful.titlebar.widget.closebutton(c),
                layout = wibox.layout.fixed.horizontal()
            },
            layout = wibox.layout.align.horizontal
        }
        if not c.floating then
            awful.titlebar.hide(c)
        end
    end
end)

-- Show titlebar for floating clients
client.connect_signal("property::floating", function (c)
    if c.floating then
        awful.titlebar.show(c)
    else
        awful.titlebar.hide(c)
    end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

-- Focused border colors
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
