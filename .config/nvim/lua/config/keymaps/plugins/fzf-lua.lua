require("config.keymaps.helpers")

map("n", "<leader><leader>", ":FzfLua <CR>", { desc = "Fzf all sources" })
map("n", "<C-p>", ":Fzf files resume=true<CR>", { desc = "Fzf Files" })
map(
  "n",
  "<C-t>",
  ":FzfLua lsp_document_symbols symbol_width=70 symbol_type_width=10 <CR>",
  { desc = "Fzf [T]ags in current buffer (LSP)" }
)
map("n", "<leader>ft", ":FzfLua treesitter <CR>", { desc = "Fzf [T]ags in current buffer (treesitter)" })
map("n", "<leader>fk", ":FzfLua keymaps <CR>", { desc = "Fzf [K]ey mappings" })
map("n", "<leader>fr", ":FzfLua resume <CR>", { desc = "Fzf [R]esume last session" })
map("n", "<leader>sw", ':FzfLua grep_cword <CR>"', { desc = "Fzf [S]earch for current [w]ord" })
