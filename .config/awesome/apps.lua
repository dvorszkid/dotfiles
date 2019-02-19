--
-- Apps used in Awesome WM
--

-- app collection for shortcuts and widgets
local apps_cmd = {
    terminal        = "urxvtc",
    tmux            = "tmux",
    tmuxs           = "tmuxs ",

    browser         = "firefox-bin",
    calculator      = "qalculate-gtk",
    procmon         = "htop",
    runcmd          = "rofi -show run",
    windowswitch    = "rofi -show window",
    screenshot      = "spectacle",
    xrandr_setup    = "xrandr-setup.sh",
    jira            = "jiraworklogger --tracking-time-only",
    jira_current    = "jiraworklogger --tracking",
    jira_adjust     = "jiraworklogger --adjust-tracking",
    translate       = "rofi-translate.sh",

    volume_inc      = "amixer set Master 4%+",
    volume_dec      = "amixer set Master 4%-",
    volume_mute     = "amixer set Master toggle",

    music           = "spotify",
    music_play      = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause",
    music_stop      = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Stop",
    music_next      = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next",
    music_prev      = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous",

    lock            = "xscreensaver-command -lock",
    shutdown        = "dbus-send --system --print-reply --dest=\"org.freedesktop.ConsoleKit\" /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.PowerOff boolean:true",
    reboot          = "dbus-send --system --print-reply --dest=\"org.freedesktop.ConsoleKit\" /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Reboot boolean:true",
    suspend         = "xrandr-setup.sh 1 && xscreensaver-command -lock && dbus-send --system --print-reply --dest=\"org.freedesktop.ConsoleKit\" /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Suspend boolean:true",
}

-- combined commands
local apps_term, apps_tmux = {}, {}
for k, a in pairs(apps_cmd) do
    apps_term["" .. k] = apps_cmd.terminal .. " -e " .. a
    apps_tmux["" .. k] = apps_cmd.terminal .. " -e " .. "tmux new-session '" .. a .. "'"
end

return {
    cmd = apps_cmd,
    term = apps_term,
    tmux = apps_tmux,
}
