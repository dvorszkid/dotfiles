--
-- Apps autostarted by Awesome WM
--
local awful = require("awful")

-- common
local apps = {
    "urxvtd",
    "unclutter",
    "parcellite",
    "tresorit --hidden",
    "redshift-gtk",
}

if not os.getenv("VNCDESKTOP") then
    apps = awful.util.table.join(apps, {
        -- vsync fix, test with: https://www.youtube.com/watch?v=5xkNy9gfKOg
        "picom -b --backend glx --vsync",
        "xss-lock -n /usr/libexec/xsecurelock/dimmer -l -- xsecurelock",
    })
end

-- local
if io.open(".config/awesome/autostartlocal.lua") ~= nil then
    local awful = require("awful")
    apps = awful.util.table.join(apps, require("autostartlocal"))
end

return apps
