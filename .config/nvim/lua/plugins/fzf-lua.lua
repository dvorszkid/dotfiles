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
    { "<leader><leader>", "<cmd>FzfLua<CR>", desc = "Fzf all sources" },

    -- Main
    { "<C-p>", "<cmd>FzfLua files<CR>", desc = "Fzf Files" },
    {
      "<C-t>",
      "<cmd>FzfLua lsp_document_symbols symbol_width=70 symbol_type_width=10<CR>",
      desc = "Fzf [T]ags in current buffer (LSP)",
    },
    { "<leader>/", "<cmd>FzfLua live_grep_resume<CR>", desc = "Fzf Grep" },

    -- Others
    { "<leader>ft", "<cmd>FzfLua treesitter<CR>", desc = "Fzf [T]ags in current buffer (treesitter)" },
    { "<leader>fk", "<cmd>FzfLua keymaps<CR>", desc = "Fzf [K]ey mappings" },
    { "<leader>fr", "<cmd>FzfLua resume<CR>", desc = "Fzf [R]esume last session" },
    { "<leader>sw", '<cmd>FzfLua grep_cword<CR>"', desc = "Fzf [S]earch for current [w]ord" },
  },
}
