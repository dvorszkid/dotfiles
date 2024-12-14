local env = require("env")

if not env.is_devel then
  return {}
end

return {
  "git@bitbucket.org:tresorit/vimtresorit.git",
  event = "VeryLazy",
  -- event = "BufEnter *tresoritcore*",
  -- ft = "c, cpp",
  dependencies = {
    {
      "tpope/vim-dispatch",
      "junegunn/fzf",
      "junegunn/fzf.vim",
    },
  },
  init = function()
    vim.g.buildcmd = ":Make "
    vim.g.buildbackgroundcmd = ":Make! -k 0 "
    vim.g.buildcmd_proxy = "run-and-notify"

    vim.keymap.set("n", "<leader>bc", ":CreateOutDir<space>", { desc = "VimTresorit Create out dir" })
    vim.keymap.set("n", "<leader>be", ":Gn args <CR>", { desc = "VimTresorit Edit args.gn" })
    vim.keymap.set("n", "<leader>bo", ":GnOut <CR>", { desc = "VimTresorit Select out dir" })
    vim.keymap.set("n", "<leader>bt", ":GnTarget <CR>", { desc = "VimTresorit Select build target" })

    vim.keymap.set("n", "<leader>bs", ":AbortDispatch <CR>", { desc = "VimTresorit Abort build" })
    vim.keymap.set(
      "n",
      "<leader>bf",
      ":wa<CR>:exec g:buildcmd . g:GetBuildFileParams(@%)<CR>",
      { desc = "VimTresorit Build file" }
    )
    vim.keymap.set(
      "n",
      "<leader>bp",
      ":wa<CR>:exec g:buildcmd . g:GetBuildProjectParams(@%)<CR>",
      { desc = "VimTresorit Build project" }
    )
    vim.keymap.set(
      "n",
      "<leader>ba",
      ":wa<CR>:exec g:buildcmd . g:GetBuildAllParams(@%)<CR>",
      { desc = "VimTresorit Build all" }
    )
    vim.keymap.set(
      "n",
      "<leader>bfb",
      ":wa<CR>:exec g:buildbackgroundcmd . g:GetBuildFileParams(@%)<CR>",
      { desc = "VimTresorit Build file in background" }
    )
    vim.keymap.set(
      "n",
      "<leader>bpb",
      ":wa<CR>:exec g:buildbackgroundcmd . g:GetBuildProjectParams(@%)<CR>",
      { desc = "VimTresorit Build project in background" }
    )
    vim.keymap.set(
      "n",
      "<leader>bab",
      ":wa<CR>:exec g:buildbackgroundcmd . g:GetBuildAllParams(@%)<CR>",
      { desc = "VimTresorit Build all in background" }
    )
    vim.keymap.set(
      "n",
      "<F7>",
      ":wa<CR>:exec g:buildcmd . g:GetBuildAllParams(@%)<CR>",
      { desc = "VimTresorit Build all" }
    )
    vim.keymap.set(
      "n",
      "<F8>",
      ":wa<CR>:exec g:buildcmd . g:GetBuildFileParams(@%)<CR>",
      { desc = "VimTresorit Build file" }
    )
  end,
}
