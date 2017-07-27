--
-- Apps autostarted by Awesome WM
--

-- common
local apps = {
	"urxvtd",
	"unclutter",
	"xscreensaver -no-splash",
	"parcellite",
	"tresorit --hidden",
}

-- local
if io.open(".config/awesome/autostartlocal.lua") ~= nil then
	local awful = require("awful")
	apps = awful.util.table.join(apps, require("autostartlocal"))
end

return apps
