require("config.keymaps.helpers")

map("n", "<C-h>", "<Cmd>NvimTmuxNavigateLeft<CR>", { silent = true })
map("n", "<C-j>", "<Cmd>NvimTmuxNavigateDown<CR>", { silent = true })
map("n", "<C-k>", "<Cmd>NvimTmuxNavigateUp<CR>", { silent = true })
map("n", "<C-l>", "<Cmd>NvimTmuxNavigateRight<CR>", { silent = true })
map("n", "<C-\\>", "<Cmd>NvimTmuxNavigateLastActive<CR>", { silent = true })
