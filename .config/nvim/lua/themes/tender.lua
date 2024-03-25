---@type Base46Table
local M = {}

-- UI
M.base_30 = {
    white = "#eeeeee",
    black = "#282828",      -- usually your theme bg
    darker_black = "#202020", -- 6% darker than black
    black2 = "#363636",     -- 6% lighter than black
    one_bg = "#3e3e3e",     -- 10% lighter than black
    one_bg2 = "#474747",    -- 6% lighter than one_bg2
    one_bg3 = "#4f4f4f",    -- 6% lighter than one_bg3
    grey = "#7e7e7e",       -- 40% lighter than black (the % here depends so choose the perfect grey!)
    grey_fg = "#8b8b8b",    -- 10% lighter than grey
    grey_fg2 = "#858585",   -- 5% lighter than grey
    light_grey = "#989898",
    red = "#f43753",
    baby_pink = "#dcc79f",
    pink = "#d3b987",
    line = "#404040", -- 15% lighter than black
    green = "#c9d05c",
    vibrant_green = "#d9de8d",
    nord_blue = "#8fb2bf",
    blue = "#b3deef",
    seablue = "#c2e5f2",
    yellow = "#ffc24b", -- 8% lighter than yellow
    sun = "#ffce6f",
    purple = "#d3b987", -- magenta
    dark_purple = "#a9946c",
    teal = "#5ca5c3",
    orange = "#ff874b",
    cyan = "#73cef4",
    statusline_bg = "#282828",
    lightbg = "#3e3e3e",
    pmenu_bg = "#989898",
    folder_bg = "#c2e5f2",
}

-- check https://github.com/chriskempson/base16/blob/master/styling.md for more info
M.base_16 = {
    base00 = "#282828", -- color00 Black (background)
    base01 = "#383838", -- color18
    base02 = "#484848", -- color19
    base03 = "#4c4c4c", -- color08 Bright_Black
    base04 = "#b8b8b8", -- color20
    base05 = "#eeeeee", -- color07 White (foreground)
    base06 = "#e8e8e8", -- color21
    base07 = "#feffff", -- color15 Bright_White
    base08 = "#f43753", -- color01 Red
    base09 = "#dc9656", -- color16
    base0A = "#ffc24b", -- color03 Yellow
    base0B = "#c9d05c", -- color02 Green
    base0C = "#73cef4", -- color06 Cyan
    base0D = "#b3deef", -- color04 Blue
    base0E = "#d3b987", -- color05 Magenta
    base0F = "#a16946", -- color17
}

-- OPTIONAL
-- overriding highlights for this specific theme only
M.polish_hl = {
    Comment = {
        fg = M.base_30.light_grey,
    },
    ["@function"] = { fg = M.base_30.blue },
    ["@function.builtin"] = { fg = M.base_30.teal },
}

-- set the theme type whether is dark or light
M.type = "dark" -- "or light"

-- this will be later used for users to override your theme table from chadrc
M = require("base46").override_theme(M, "tender")

return M
