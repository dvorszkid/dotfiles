return {
  "mfussenegger/nvim-lint",
  opts = {
    linters = {
      -- Previously used by LazyVim
      markdownlint = {
        args = { "--disable", "MD013", "--" },
      },
      -- Currently used by LazyVim
      ["markdownlint-cli2"] = {
        args = { "--config", vim.fn.expand("~/.config/nvim/lua/plugins/.markdownlint-cli2.yaml"), "--" },
      },
    },
  },
}
