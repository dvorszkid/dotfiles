vim.api.nvim_create_user_command("DapProjectSearch", function()
	require("nvim-dap-projects").search_project_config()
end, {})
