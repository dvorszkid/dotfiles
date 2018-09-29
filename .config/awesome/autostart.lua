--
-- Apps autostarted by Awesome WM
--

-- common
local apps = {
    "urxvtd",
    -- vsync fix, test with: https://www.youtube.com/watch?v=5xkNy9gfKOg
    "compton -b --backend glx --vsync opengl-swc --paint-on-overlay",
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
