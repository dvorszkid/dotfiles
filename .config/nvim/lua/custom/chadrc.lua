---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
local highlights = require("custom.highlights")

M.ui = {
	theme = "vscode_dark",
	theme_toggle = { "vscode_dark", "one_light" },

	changed_themes = {
		vscode_dark = {
			base_16 = {
				-- base00 = "#1e1e1e",
			},
			base_30 = {
				-- black = "#1e1e1e",
				grey = "#555555",
				-- statusline_bg = "#202020",
				light_grey = "#909090",
			},
		},
	},

	hl_override = highlights.override,
	hl_add = highlights.add,

	statusline = {
		theme = "default",
		separator_style = "block",
	},
}

M.plugins = "custom.plugins"

-- check core.mappings for table structure
M.mappings = require("custom.mappings")

return M
