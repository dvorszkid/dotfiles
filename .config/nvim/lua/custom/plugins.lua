local overrides = require("custom.configs.overrides")
local env = require("custom.env")

---@type NvPluginSpec[]
local plugins = {
	--
	-- Override plugins
	--
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- format & linting
			{
				"jose-elias-alvarez/null-ls.nvim",
				config = function()
					require("custom.configs.null-ls")
				end,
			},
		},
		config = function()
			require("plugins.configs.lspconfig")
			require("custom.configs.lspconfig")
		end, -- Override to setup mason-lspconfig
	},

	{
		"williamboman/mason.nvim",
		opts = overrides.mason,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		opts = overrides.treesitter,
	},

	{
		"nvim-tree/nvim-tree.lua",
		opts = overrides.nvimtree,
	},

	--
	-- New plugins
	--
	-- Misc
	{
		"alexghergh/nvim-tmux-navigation",
		event = "VeryLazy",
		config = function()
			require("custom.configs.tmux-navigation")
		end,
	},
	{
		"Lokaltog/vim-easymotion",
		lazy = false,
		init = function()
			require("custom.configs.easymotion")
		end,
	},
	{ "tpope/vim-repeat", lazy = false },
	{ "tpope/vim-unimpaired", lazy = false },
	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	},
	{ "qwertologe/nextval.vim", lazy = false },
	{ "svermeulen/vim-subversive" },
	{
		"machakann/vim-highlightedyank",
		lazy = false,
		init = function()
			require("custom.configs.highlightedyank")
		end,
	},
	{
		"Valloric/ListToggle",
		lazy = false,
		init = function()
			require("custom.configs.listtoggle")
		end,
	},

	-- Git
	{ "tpope/vim-fugitive", cmd = "Git" },
	{ "tpope/vim-git" },
	{ "kdheepak/lazygit.nvim", cmd = "LazyGit" },

	-- To make a plugin not be loaded
	-- {
	--   "NvChad/nvim-colorizer.lua",
	--   enabled = false
	-- },

	-- All NvChad plugins are lazy-loaded by default
	-- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
	-- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
	-- {
	--   "mg979/vim-visual-multi",
	--   lazy = false,
	-- }
}

if env.is_devel then
	table.insert(plugins, { "ngg/vim-gn", ft = "gn" })
	table.insert(plugins, { "uarun/vim-protobuf", ft = "proto" })
	table.insert(plugins, {
		"rust-lang/rust.vim",
		ft = "rust",
		init = function()
			vim.g.rustfmt_autosave = 1
		end,
	})
	table.insert(plugins, {
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
			require("custom.configs.vimtresorit")
		end,
	})
end

return plugins
