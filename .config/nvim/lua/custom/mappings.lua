---@type MappingsTable
local M = {}

M.disabled = {
  n = {
    ["<C-c>"] = "", -- Copy file contents to clipboard
    ["<leader>fw"] = "", -- Telescope live grep
    ["<leader>fz"] = "", -- Telescope find in current buffer
  }
}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
  }
}

M.telescope = {
  n = {
    ["<C-p>"] = {":Telescope find_files <CR>", "Find Files"},
    ["<C-t>"] = {":Telescope lsp_document_symbols <CR>", "Tags in in current buffer"},
    ["<leader>fg"] = {":Telescope live_grep <CR>", "Live Grep (rg)"},
    ["<leader>f/"] = {":Telescope current_buffer_fuzzy_find <CR>", "Find in current buffer"},
    ["<leader>ft"] = {":Telescope lsp_document_symbols <CR>", "Tags in in current buffer"},
    ["<leader>fr"] = {":Telescope resume <CR>", "Resume last Telescope session"},
  },
}

-- more keybinds!

return M
