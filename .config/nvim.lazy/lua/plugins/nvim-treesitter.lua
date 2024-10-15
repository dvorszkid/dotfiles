return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      -- vim
      "vim",
      "lua",

      -- script
      "bash",
      "python",

      -- native
      "c",
      "cpp",
      "rust",

      -- other
      "c_sharp",
      "objc",

      -- web
      "html",
      "css",
      "javascript",
      "typescript",
      "tsx",

      -- misc
      "markdown",
      "markdown_inline",
      "json",
      "toml",
    },
    indent = {
      enable = true,
      -- disable = {
      --   "python"
      -- },
    },
  },
}
