--
-- Apps used in Awesome WM
--
local awful = require("awful")
local naughty = require("naughty")
local beautiful = require("beautiful")

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

    music           = "spotify",
    music_play      = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause",
    music_stop      = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Stop",
    music_next      = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next",
    music_prev      = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous",

    lock            = "xset s activate",
    shutdown        = "dbus-send --system --print-reply --dest=\"org.freedesktop.ConsoleKit\" /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.PowerOff boolean:true",
    reboot          = "dbus-send --system --print-reply --dest=\"org.freedesktop.ConsoleKit\" /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Reboot boolean:true",
    suspend         = "xrandr-setup.sh 1 && xset s activate && dbus-send --system --print-reply --dest=\"org.freedesktop.ConsoleKit\" /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Suspend boolean:true",
}

-- combined commands
local apps_term, apps_tmux = {}, {}
for k, a in pairs(apps_cmd) do
    apps_term["" .. k] = apps_cmd.terminal .. " -e " .. a
    apps_tmux["" .. k] = apps_cmd.terminal .. " -e " .. "tmux new-session '" .. a .. "'"
end

-- Functions
local funcs = {
    volume_toggle = function()
            awful.spawn.easy_async(string.format("%s set %s toggle", beautiful.volume.cmd, beautiful.volume.togglechannel or beautiful.volume.channel), function(out)
                beautiful.volume.update()
            end)
        end,
    volume_increase = function()
            awful.spawn.easy_async(string.format("%s set %s 2%%+", beautiful.volume.cmd, beautiful.volume.channel), function(out)
                beautiful.volume.update()
            end)
        end,
    volume_decrease = function()
            awful.spawn.easy_async(string.format("%s set %s 2%%-", beautiful.volume.cmd, beautiful.volume.channel), function(out)
                beautiful.volume.update()
            end)
        end,

    notifications_toggle = function ()
        if not naughty.is_suspended() then
            naughty.destroy_all_notifications()
        end
        naughty.toggle()
        beautiful.donotdisturb_widget.visible = naughty.is_suspended()
    end,
}

return {
    cmd = apps_cmd,
    term = apps_term,
    tmux = apps_tmux,
    func = funcs,
}
