return {
  "gbprod/substitute.nvim",
  opts = {},
  keys = {
    {
      "s",
      function()
        require("substitute").operator()
      end,
      noremap = true,
      desc = "Substitute (motion)",
    },
    {
      "ss",
      function()
        require("substitute").line()
      end,
      noremap = true,
      desc = "Substitute (line)",
    },
    -- used by Flash
    -- {
    --   "S",
    --   function()
    --     require("substitute").eol()
    --   end,
    --   noremap = true,
    --   desc = "Substitute (EOL)",
    -- },
    {
      mode = "x",
      "s",
      function()
        require("substitute").visual()
      end,
      noremap = true,
      desc = "Substitute (visual)",
    },
  },
}
