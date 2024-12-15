return {
  "stevearc/overseer.nvim",
  opts = {
    task_list = {
      max_height = { 20, 0.3 },
    },
  },
  keys = {
    { "<F7>", "<cmd>OverseerOpen!<CR><cmd>OverseerRun<CR>" },
    { "<F8>", "<cmd>OverseerToggle<CR>" },
  },
}
