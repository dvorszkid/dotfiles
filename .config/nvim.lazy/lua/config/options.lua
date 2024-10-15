-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

--
-- Indent and tab settings
--
vim.opt.smartindent = true
--vim.opt.tabstop = 4
vim.opt.softtabstop = 0
vim.opt.expandtab = true
--vim.opt.shiftwidth = 4
vim.opt.smarttab = true

--
-- Searching
--
vim.opt.ignorecase = true -- ignore case when searching
vim.opt.smartcase = true -- ignore case if search pattern is all lowercase, case-sensitive otherwise
vim.opt.hlsearch = true -- highlight search terms
vim.opt.incsearch = true -- show search matches as you type
vim.opt.gdefault = true -- use /g by default search and replace

--
-- Misc
--
vim.opt.backspace = { "indent", "eol", "start" } -- allow backspacing over everything in insert mode
vim.opt.number = true -- line numbers
vim.opt.relativenumber = false -- relative line numbers
vim.opt.cursorline = true -- highlight cursor line
vim.opt.wildmenu = true -- for better completion
vim.opt.wildoptions = "pum" -- to show completions in a popup (since vim9)
vim.opt.ch = 1 -- command line height
vim.opt.mouse = "a" -- enable mouse scrolling
vim.opt.scrolloff = 8 -- show more lines before and after cursor
vim.opt.wildignore = "*.swp,*.bak,*.pyc,*.class"
vim.opt.title = true -- change the terminal's title
--vim.opt.t_ts = "]0;"			                -- title string begin for rxvt-unicode + tmux
--vim.opt.t_fs = ""				                -- title string end for rxvt-unicode + tmux
vim.opt.visualbell = true -- don't beep
vim.opt.errorbells = false -- don't beep
vim.opt.showmatch = true -- show matching parens
vim.opt.laststatus = 2 -- always show status line
vim.opt.showmode = false -- hide default mode text
vim.opt.hidden = true -- dave modified buffers in the background
vim.opt.autoread = true -- auto-reload modified files (with no local changes)
vim.opt.updatetime = 300 -- check for changes in every second
--vim.opt.lazyredraw = true			-- no redraws in macros; LazyVim complains about it
vim.opt.confirm = true -- dialog when :q, :w, :x, :wq fails
vim.opt.startofline = false -- don't move cursor when switching buffers/files
vim.opt.backup = false -- that's what git is for
vim.opt.swapfile = false -- no .swp files
vim.opt.ttyfast = true -- smoother changes
vim.opt.diffopt:append("vertical") -- vertical diff
vim.opt.listchars = { tab = "▸ ", eol = "¬" } -- This changes the default display of tab and CR chars in list mode
vim.opt.foldlevelstart = 99 -- all folds open by default
vim.opt.spelllang = "en" -- mostly the only needed
vim.opt.spell = false -- and its on
vim.opt.timeoutlen = 400 -- also used by vim-which-key plugin
vim.opt.ttimeoutlen = 0 -- timeout of keycode sequences - faster Esc in insert mode
vim.opt.display:append("lastline") -- try to show as much as possible of the last line in the window (rather than a column of --@--)
vim.opt.secure = true -- disable unsafe commands in local .vimrc files

vim.g.leave_my_textwidth_alone = 1 -- Ignore gentoo specific global vimrc
vim.g.vim_json_conceal = 0 -- Disable quote concealing in JSON files

--
-- Undo and history
--
vim.opt.history = 1000 -- remember more commands and search history
vim.opt.undolevels = 1000 -- use many muchos levels of undo
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"
vim.opt.undofile = true

--
-- GUI settings
--
if vim.fn.has("gui_running") then
  vim.opt.guifont = "FiraCode Nerd Font 9"
end

-- Search and Replace
if vim.fn.executable("rg") then
  vim.opt.grepprg = "rg --vimgrep --no-heading --hidden"
  vim.opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
elseif vim.fn.executable("ag") then
  vim.opt.grepprg = "ag --nogroup --nocolor"
end
