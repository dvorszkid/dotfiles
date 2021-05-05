--
-- Apps used in Awesome WM
--
local awful = require("awful")
local naughty = require("naughty")
local beautiful = require("beautiful")
local ui  = require("ui")

-- app collection for shortcuts and widgets
local apps_cmd = {
    terminal        = "urxvtc",
    tmux            = "tmux",
    tmuxs           = "tmuxs ",

    browser         = "firefox-bin",
    calculator      = "qalculate-gtk",
    termcalculator  = "urxvtc -geometry 60x30 -e qalc",
    procmon         = "htop",
    runcmd          = "rofi -show run",
    windowswitch    = "rofi -show window",
    screenshot      = "spectacle",
    xrandr_setup    = "xrandr-setup.sh",
    jira            = "jiraworklogger --tracking-time-only",
    jira_current    = "jiraworklogger --tracking",
    jira_adjust     = "jiraworklogger --adjust-tracking",
    translate       = "rofi-translate.sh",
    volume          = "alsamixer",
    calendar        = "xdg-open https://calendar.google.com",

    amplifier_toggle      = "yamaha toggle",
    amplifier_volume_up   = "yamaha volume_up",
    amplifier_volume_down = "yamaha volume_down",

    music           = "spotify",
    music_play      = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause",
    music_stop      = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Stop",
    music_next      = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next",
    music_prev      = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous",

    lock            = "xset s activate",
    shutdown        = "loginctl poweroff",
    reboot          = "loginctl reboot",
    suspend         = "xset s activate && sleep 1 && loginctl suspend",
}

if hostname == "basestar" then
    apps_cmd['suspend'] =  "yamaha standby && xrandr-setup.sh 1 && " .. apps_cmd['suspend']
end

-- combined commands
local apps_term, apps_tmux = {}, {}
for k, a in pairs(apps_cmd) do
    apps_term["" .. k] = apps_cmd.terminal .. " -e " .. a
    apps_tmux["" .. k] = apps_cmd.terminal .. " -e " .. "tmux new-session '" .. a .. "'"
end

-- Functions
local funcs = {
    volume_toggle = function()
            awful.spawn.easy_async(string.format("%s set %s toggle", ui.volume.cmd, ui.volume.togglechannel or ui.volume.channel), function(out)
                ui.volume.update()
            end)
        end,
    volume_increase = function()
            awful.spawn.easy_async(string.format("%s set %s 2%%+", ui.volume.cmd, ui.volume.channel), function(out)
                ui.volume.update()
            end)
        end,
    volume_decrease = function()
            awful.spawn.easy_async(string.format("%s set %s 2%%-", ui.volume.cmd, ui.volume.channel), function(out)
                ui.volume.update()
            end)
        end,

    notifications_toggle = function ()
        new_state = "Do Not Disturb ON"
        if not naughty.is_suspended() then
            ui.donotdisturb_icon.opacity = 1
            naughty.config.notify_callback = function(args) return nil end
            naughty.destroy_all_notifications()
        else
            new_state = "Do Not Disturb OFF"
            ui.donotdisturb_icon.opacity = 0.2
            naughty.config.notify_callback = function(args) return args end
        end
        ui.donotdisturb_icon:emit_signal("widget::redraw_needed")
        ui.donotdisturb_tooltip.text = new_state
        naughty.toggle()
    end,
}

return {
    cmd = apps_cmd,
    term = apps_term,
    tmux = apps_tmux,
    func = funcs,
}
