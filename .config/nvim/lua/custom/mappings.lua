---@type MappingsTable
local M = {}

M.disabled = {
	n = {
		["<C-c>"] = "", -- Copy file contents to clipboard
		["<leader>fw"] = "", -- Telescope live grep
		["<leader>fz"] = "", -- Telescope find in current buffer
		["[c"] = "", -- Gitsigns stuff ...
		["]c"] = "",
		["<leader>rh"] = "",
		["<leader>td"] = "",
		["<leader>ph"] = "",
		["<leader>gb"] = "",
	},
}

M.general = {
	n = {
		[";"] = { ":", "enter command mode", opts = { nowait = true } },
	},
}

M.subversive = {
	n = {
		["s"] = { "<plug>(SubversiveSubstitute)", "Substitute (+ motion)" },
		["ss"] = { "<plug>(SubversiveSubstituteLine)", "Substitute line" },
	},
}

M.gitsigns = {
	n = {
		["<leader>gb"] = { ":Gitsigns toggle_current_line_blam<CR>", "Toggle current line blame" },
		["<leader>hp"] = { ":Gitsigns preview_hunk<CR>", "Preview hunk" },
		["<leader>hs"] = { ":Gitsigns stage_hunk<CR>", "Stage hunk" },
		["<leader>hr"] = { ":Gitsigns reset_hunk<CR>", "Reset hunk" },
		["[h"] = { ":Gitsigns prev_hunk<CR>", "Jump to prev hunk" },
		["]h"] = { ":Gitsigns next_hunk<CR>", "Jump to next hunk" },
	},
}

M.easymotion = {
	n = {
		["S"] = { "<Plug>(easymotion-s2)", "Start EasyMotion" },
	},
	o = {
		["t"] = { "<Plug>(easymotion-t)", "Motion [t]ill ..." },
		["/"] = { "<Plug>(easymotion-tn)", "Motion find ..." },
	},
}

M.nextval = {
	n = {
		["-"] = { "<Plug>nextvalDec", "Decrease number" },
		["+"] = { "<Plug>nextvalInc", "Increase number" },
	},
}

M.telescope = {
	n = {
		["<C-p>"] = { ":Telescope find_files <CR>", "Find Files" },
		["<C-t>"] = { ":Telescope lsp_document_symbols <CR>", "Tags in in current buffer (LSP)" },
		["<leader>fg"] = { ":Telescope live_grep <CR>", "Live Grep (rg)" },
		["<leader>f/"] = { ":Telescope current_buffer_fuzzy_find <CR>", "Find in current buffer" },
		["<leader>ft"] = { ":Telescope treesitter <CR>", "Tags in in current buffer (treesitter)" },
		["<leader>fk"] = { ":Telescope keymaps <CR>", "Key mappings" },
		["<leader>fr"] = { ":Telescope resume <CR>", "Resume last Telescope session" },
	},
}

M.lspconfig = {
	n = {
		["<F4>"] = { ":ClangdSwitchSourceHeader <CR>", "Switch to header/source" },
	},
}

M.vimtresorit = {
	n = {
		["<leader>bc"] = { ":CreateOutDir<space>", "Create out dir" },
		["<leader>be"] = { ":Gn args <CR>", "Edit args.gn" },
		["<leader>bo"] = { ":GnOut <CR>", "Select out dir" },
		["<leader>bt"] = { ":GnTarget <CR>", "Select build target" },

		["<leader>bs"] = { ":AbortDispatch <CR>", "Abort build" },
		["<leader>bf"] = { ":wa<CR>:exec g:buildcmd . g:GetBuildFileParams(@%)<CR>", "Build file" },
		["<leader>bp"] = { ":wa<CR>:exec g:buildcmd . g:GetBuildProjectParams(@%)<CR>", "Build project" },
		["<leader>ba"] = { ":wa<CR>:exec g:buildcmd . g:GetBuildAllParams(@%)<CR>", "Build all" },
		["<leader>bfb"] = {
			":wa<CR>:exec g:buildbackgroundcmd . g:GetBuildFileParams(@%)<CR>",
			"Build file in background",
		},
		["<leader>bpb"] = {
			":wa<CR>:exec g:buildbackgroundcmd . g:GetBuildProjectParams(@%)<CR>",
			"Build project in background",
		},
		["<leader>bab"] = {
			":wa<CR>:exec g:buildbackgroundcmd . g:GetBuildAllParams(@%)<CR>",
			"Build all in background",
		},
		["<F7>"] = { ":wa<CR>:exec g:buildcmd . g:GetBuildAllParams(@%)<CR>", "Build all" },
		["<F8>"] = { ":wa<CR>:exec g:buildcmd . g:GetBuildFileParams(@%)<CR>", "Build file" },
	},
}

-- more keybinds!

return M
