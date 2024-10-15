-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
require("config.keymaps.helpers")

-- Buffer switch
map("n", "<F1>", ":bp<CR>", { desc = "Buffer Goto prev", silent = true })
map("n", "<F2>", ":bn<CR>", { desc = "Buffer Goto next", silent = true })

-- More natural line positioning on wrapped lines
map("n", "j", "gj")
map("n", "k", "gk")
map("n", "J", "gJ")
map("n", "K", "gK")

-- Scroll slightly faster
map("", "<c-e>", "<c-e><c-e><c-e>")
map("", "<c-y>", "<c-y><c-y><c-y>")

-- Keep visual selection after indenting
map("v", ">", ">gv")
map("v", "<", "<gv")

-- Visually select the text that was last edited/pasted
--
map("n", "gV", "`[v`]", { noremap = false })

-- With this map, we can select some text in visual mode and by invoking the map,
-- have the selection automatically filled in as the search text and the cursor
-- placed in the position for typing the replacement text. Also, this will ask
-- for confirmation before it replaces any instance of the search text in the
-- file.
map("v", "<C-r>", '"hy:%s/<C-r>h//c<left><left>')

-- Better regex syntax
-- nnoremap / /\v
-- vnoremap / /\v

-- Now we don't have to move our fingers so far when we want to scroll through
-- the command history; also, don't forget the q: command (see :h q: for more
-- info)
map("c", "<c-j>", "<down>")
map("c", "<c-k>", "<up>")

-- In normal mode, we use : much more often than ; so lets swap them.
-- WARNING: this will cause any "ordinary" map command without the "nore" prefix
-- that uses ":" to fail. For instance, "map <f2> :w" would fail, since vim will
-- read ":w" as ";w" because of the below remappings. Use "noremap"s in such
-- situations and you'll be fine.
map("n", ";", ":")
map("n", ":", ";")
map("v", ";", ":")
map("v", ":", ";")

-- C++ shortcuts
map("n", "<leader>sm", "ysiw)istd::move<Esc>", { noremap = false })
map("n", "<leader>fe", ":botright copen 15<CR>/error:<CR>", { silent = true })
map("n", "<leader>fw", ":botright copen 15<CR>/warning:<CR>", { silent = true })

-- Plugins
require("config.keymaps.plugins.nvim-tmux-navigator")
require("config.keymaps.plugins.lsp")
require("config.keymaps.plugins.telescope")
