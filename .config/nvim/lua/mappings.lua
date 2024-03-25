require("nvchad.mappings")

local map = vim.keymap.set

-- Basic
map("n", ";", ":")
map("i", "jk", "<ESC>")

-- Subversive
map("n", "s", "<plug>(SubversiveSubstitute)", { desc = "Substitute (+ motion)" })
map("n", "ss", "<plug>(SubversiveSubstituteLine)", { desc = "Substitute line" })

-- Git
map("n", "<leader>gb", ":Gitsigns toggle_current_line_blame<CR>", { desc = "Git Toggle current line blame" })
map("n", "<leader>hp", ":Gitsigns preview_hunk<CR>", { desc = "Git Preview hunk" })
map("n", "<leader>hs", ":Gitsigns stage_hunk<CR>", { desc = "Git Stage hunk" })
map("n", "<leader>hr", ":Gitsigns reset_hunk<CR>", { desc = "Git Reset hunk" })
map("n", "[h", ":Gitsigns prev_hunk<CR>", { desc = "Git Jump to prev hunk" })
map("n", "]h", ":Gitsigns next_hunk<CR>", { desc = "Git Jump to next hunk" })
map("n", "<leader>gg", ":LazyGit<CR>", { desc = "Git Open LazyGit" })

-- EasyMotion
map("n", "S", "<Plug>(easymotion-s2)", { desc = "EasyMotion Start" })
map("o", "t", "<Plug>(easymotion-t)", { desc = "EasyMotion Motion [t]ill ..." })
map("o", "/", "<Plug>(easymotion-tn)", { desc = "EasyMotion Motion find ..." })

-- Nextval
map("n", "-", "<Plug>nextvalDec", { desc = "Nextval Decrease number" })
map("n", "+", "<Plug>nextvalInc", { desc = "Nextval Increase number" })

-- Telescope
map("n", "<C-p>", ":Telescope find_files <CR>", { desc = "Telescope Find Files" })
map(
    "n",
    "<C-t>",
    ":Telescope lsp_document_symbols symbol_width=70 symbol_type_width=10 <CR>",
    { desc = "Telescope [T]ags in current buffer (LSP)" }
)
map("n", "<leader>fg", ":Telescope live_grep <CR>", { desc = "Telescope Live [G]rep (rg)" })
map("n", "<leader>f/", ":Telescope current_buffer_fuzzy_find <CR>", { desc = "Telescope [F]ind in current buffer" })
map("n", "<leader>ft", ":Telescope treesitter <CR>", { desc = "Telescope [T]ags in current buffer (treesitter)" })
map("n", "<leader>fk", ":Telescope keymaps <CR>", { desc = "Telescope [K]ey mappings" })
map("n", "<leader>fr", ":Telescope resume <CR>", { desc = "Telescope [R]esume last session" })
map("n", "<leader>sw", 'yiw:Telescope live_grep <CR><C-r>"', { desc = "Telescope [S]earch for current [w]ord" })

-- Navigation
map("n", "<F4>", ":ClangdSwitchSourceHeader <CR>", { desc = "Navigation Switch to header/source" })

-- VimTresorit
map("n", "<leader>bc", ":CreateOutDir<space>", { desc = "VimTresorit Create out dir" })
map("n", "<leader>be", ":Gn args <CR>", { desc = "VimTresorit Edit args.gn" })
map("n", "<leader>bo", ":GnOut <CR>", { desc = "VimTresorit Select out dir" })
map("n", "<leader>bt", ":GnTarget <CR>", { desc = "VimTresorit Select build target" })

map("n", "<leader>bs", ":AbortDispatch <CR>", { desc = "VimTresorit Abort build" })
map("n", "<leader>bf", ":wa<CR>:exec g:buildcmd . g:GetBuildFileParams(@%)<CR>", { desc = "VimTresorit Build file" })
map(
    "n",
    "<leader>bp",
    ":wa<CR>:exec g:buildcmd . g:GetBuildProjectParams(@%)<CR>",
    { desc = "VimTresorit Build project" }
)
map("n", "<leader>ba", ":wa<CR>:exec g:buildcmd . g:GetBuildAllParams(@%)<CR>", { desc = "VimTresorit Build all" })
map(
    "n",
    "<leader>bfb",
    ":wa<CR>:exec g:buildbackgroundcmd . g:GetBuildFileParams(@%)<CR>",
    { desc = "VimTresorit Build file in background" }
)
map(
    "n",
    "<leader>bpb",
    ":wa<CR>:exec g:buildbackgroundcmd . g:GetBuildProjectParams(@%)<CR>",
    { desc = "VimTresorit Build project in background" }
)
map(
    "n",
    "<leader>bab",
    ":wa<CR>:exec g:buildbackgroundcmd . g:GetBuildAllParams(@%)<CR>",
    { desc = "VimTresorit Build all in background" }
)
map("n", "<F7>", ":wa<CR>:exec g:buildcmd . g:GetBuildAllParams(@%)<CR>", { desc = "VimTresorit Build all" })
map("n", "<F8>", ":wa<CR>:exec g:buildcmd . g:GetBuildFileParams(@%)<CR>", { desc = "VimTresorit Build file" })
