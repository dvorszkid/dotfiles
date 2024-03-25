-- This file  needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
local highlights = require("highlights")

M.ui = {
  theme = "tender",
  theme_toggle = { "tender", "one_light" },

  changed_themes = {
    tender = {
      base_16 = {
        -- base00 = "#282828",
      },
      base_30 = {
        -- black = "#282828",
        -- grey = "#555555",
        -- statusline_bg = "#202020",
        -- light_grey = "#909090",
      },
    },
  },

  hl_override = highlights.override,
  hl_add = highlights.add,

  statusline = {
    theme = "default",
    separator_style = "block",
  },
}

return M
