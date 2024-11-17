require("config.keymaps.helpers")

map("n", "<leader><leader>", ":Telescope <CR>", { desc = "Telescope all sources" })
map("n", "<C-p>", ":Telescope find_files <CR>", { desc = "Telescope Find Files" })
map(
  "n",
  "<C-t>",
  ":Telescope lsp_document_symbols symbol_width=70 symbol_type_width=10 <CR>",
  { desc = "Telescope [T]ags in current buffer (LSP)" }
)
map("n", "<leader>fg", ":Telescope live_grep <CR>", { desc = "Telescope Live [G]rep (rg)" })
map("n", "<leader>f/", ":Telescope current_buffer_fuzzy_find <CR>", { desc = "Telescope [F]ind in current buffer" })
map("n", "<leader>ft", ":Telescope treesitter <CR>", { desc = "Telescope [T]ags in current buffer (treesitter)" })
map("n", "<leader>fk", ":Telescope keymaps <CR>", { desc = "Telescope [K]ey mappings" })
map("n", "<leader>fr", ":Telescope resume <CR>", { desc = "Telescope [R]esume last session" })
map("n", "<leader>sw", 'yiw:Telescope live_grep <CR><C-r>"', { desc = "Telescope [S]earch for current [w]ord" })
