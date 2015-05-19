--
-- Apps used in Awesome WM
--

-- autostart
local autostart = {}
autostart["common"] = {
	"urxvtd",
	"unclutter",
	"xscreensaver -no-splash",
	"klipper",
	"skype",
}
autostart["basestar"] = {
}
autostart["bp1-dsklin"] = {
	"sleep 1 && tresorit-control-panel",
}

-- app collection for shortcuts and widgets
local apps_cmd = {
	terminal		= "urxvtc",
	tmux			= "tmux",
	tmux_session	= "tmux -2 new-session -A -D -s ",
	editor			= os.getenv("EDITOR") or "vi" or "mcedit",

	browser			= "opera-developer",
	filemanager		= "krusader",
	calculator		= "qalculate-gtk",
	irc				= "weechat",
	procmon			= "htop",
	dmenu			= "dmenu_run -i -l 15 -p 'run:'" ,

	volume			= "alsamixer",
	volume_inc		= "amixer -q set Master 4%+",
	volume_dec		= "amixer -q set Master 4%-",
	volume_mute		= "amixer -q set Master playback toggle",

	music			= "spotify",
	music_play		= "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause",
	music_stop		= "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Stop",
	music_next		= "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next",
	music_prev		= "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous",

	lock			= "xscreensaver-command -lock",
	shutdown		= "sudo /sbin/poweroff",
	reboot			= "sudo /sbin/reboot",
	suspend			= "xscreensaver-command -lock && sudo /usr/sbin/pm-suspend",
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
	autostart = autostart,
}
