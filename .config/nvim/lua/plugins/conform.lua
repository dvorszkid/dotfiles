return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      python = { "black" },
      gn = { "gn" },
    },
    default_format_opts = {
      timeout_ms = 5000,
    },
  },
}
