return {
  "alexghergh/nvim-tmux-navigation",
  config = function()
    local nvim_tmux_nav = require("nvim-tmux-navigation")
    nvim_tmux_nav.setup({
      disable_when_zoomed = true,
      -- defaults to false
      keybindings = {
        left = "<C-h>",
        down = "<C-j>",
        up = "<C-k>",
        right = "<C-l>",
        --last_active = "<C-\\>",
        --next = "<C-Space>",
      },
    })
  end,
  keys = {
    -- Repeated here as well, for lazy plugin activation
    { "<C-h>" },
    { "<C-j>" },
    { "<C-k>" },
    { "<C-l>" },
    -- { "<C-\\>" },
  },
}
