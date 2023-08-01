---@type MappingsTable
local M = {}

M.disabled = {
  n = {
    ["<C-c>"] = "", -- Copy file contents to clipboard
    ["<leader>fw"] = "", -- Telescope live grep
  }
}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },

    ["<C-p>"] = {":Telescope find_files <CR>", "Find Files"},
    ["<leader>fg"] = {":Telescope live_grep <CR>", "Live Grep (rg)"},
    ["<leader>fr"] = {":Telescope resume <CR>", " Resume last Telescope session"},
  },
}

-- more keybinds!

return M
