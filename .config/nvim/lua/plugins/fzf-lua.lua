return {
  "ibhagwan/fzf-lua",
  opts = {
    files = {
      git_icons = false,
    },
    grep = {
      git_icons = false,
    },
  },
  keys = {
    -- Generic
    { "<leader><leader>", ":FzfLua <CR>", desc = "Fzf all sources" },

    -- Main
    { "<C-p>", ":Fzf files <CR>", desc = "Fzf Files" },
    {
      "<C-t>",
      ":FzfLua lsp_document_symbols symbol_width=70 symbol_type_width=10 <CR>",
      desc = "Fzf [T]ags in current buffer (LSP)",
    },

    -- Others
    { "<leader>ft", ":FzfLua treesitter <CR>", desc = "Fzf [T]ags in current buffer (treesitter)" },
    { "<leader>fk", ":FzfLua keymaps <CR>", desc = "Fzf [K]ey mappings" },
    { "<leader>fr", ":FzfLua resume <CR>", desc = "Fzf [R]esume last session" },
    { "<leader>sw", ':FzfLua grep_cword <CR>"', desc = "Fzf [S]earch for current [w]ord" },
  },
}
