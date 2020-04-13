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

    music           = "spotify",
    music_play      = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause",
    music_stop      = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Stop",
    music_next      = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next",
    music_prev      = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous",

    lock            = "xset s activate",
    shutdown        = "dbus-send --system --print-reply --dest=\"org.freedesktop.ConsoleKit\" /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.PowerOff boolean:true",
    reboot          = "dbus-send --system --print-reply --dest=\"org.freedesktop.ConsoleKit\" /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Reboot boolean:true",
    suspend         = "xset s activate && dbus-send --system --print-reply --dest=\"org.freedesktop.ConsoleKit\" /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Suspend boolean:true",
}

if hostname == "basestar" then
    apps_cmd['suspend'] =  "xrandr-setup.sh 1 && yamaha standby && " .. apps_cmd['suspend']
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
        new_state = "ON"
        naughty.destroy_all_notifications()
        if not naughty.is_suspended() then
            new_state = "OFF"
        end
        naughty.notify({preset = naughty.config.presets.system, text = "Notifications " .. new_state})
        naughty.toggle()
        ui.donotdisturb_widget.visible = naughty.is_suspended()
    end,
}

return {
    cmd = apps_cmd,
    term = apps_term,
    tmux = apps_tmux,
    func = funcs,
}
