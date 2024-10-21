return {
  "folke/flash.nvim",
  keys = {
    { "s", false, mode = { "n", "x" } },
    {
      "S",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
      desc = "Flash",
    },
  },
}
