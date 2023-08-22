local M = {}

M.treesitter = {
	ensure_installed = {
		-- vim
		"vim",
		"lua",

		-- script
		"bash",
		"python",

		-- native
		"c",
		"cpp",
		"rust",

		-- other
		"c_sharp",
		"objc",

		-- web
		"html",
		"css",
		"javascript",
		"typescript",
		"tsx",

		-- misc
		"markdown",
		"markdown_inline",
		"json",
		"toml",
	},
	indent = {
		enable = true,
		-- disable = {
		--   "python"
		-- },
	},
}

M.mason = {
	ensure_installed = {
		-- lua
		"lua-language-server",
		"stylua",

		-- python
		"pyright",
		"mypy",
		"ruff",
		"black",

		-- native
		-- "clangd",
		-- "clang-format",
		"rust-analyzer",

		-- web
		"css-lsp",
		"html-lsp",
		"typescript-language-server",
		"prettier",
	},
}

-- git support in nvimtree
M.nvimtree = {
	git = {
		enable = true,
	},

	renderer = {
		highlight_git = true,
		icons = {
			show = {
				git = true,
			},
		},
	},
}

return M
