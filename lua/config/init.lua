local M = {}

function M.setup()
	if vim.g.nvim_config_initialized then
		return
	end
	vim.g.nvim_config_initialized = true
	if vim.fn.has("nvim-0.12") ~= 1 then
		error("This configuration requires Neovim 0.12 or newer")
	end
	if vim.g.vscode then
		require("vscode-nvim-config.init")
		return
	end
	require("core.mason-path")
	require("core.options")
	require("config.runtime").setup()
	require("core.autocmds")
	require("config.diagnostics").setup()
	require("core.keymaps")
	require("configs.templates")
	if vim.g.neovide then
		require("configs.neovide")
	end
	require("config.lazy").setup()
	require("config.ui").setup()
	require("config.health").setup()
	require("config.tools").setup()
	vim.api.nvim_create_user_command("CppRun", function()
		require("config.cpp-debug").run()
	end, { desc = "Build and run C/C++ without a debugger", force = true })
end

return M
