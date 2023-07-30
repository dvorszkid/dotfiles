---@type MappingsTable
local M = {}

M.disabled = {
  n = {
    ["<C-c>"] = "",
  }
}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
  },
}

-- more keybinds!

return M
