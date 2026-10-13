local M = {}
function M.install()
	local registry = require("mason-registry")
	registry.refresh(function(ok)
		if ok == false then
			vim.notify("Mason registry refresh failed", vim.log.levels.ERROR)
			return
		end
		for _, name in ipairs(require("configs.langs.mason").ensure_installed) do
			local found, pkg = pcall(registry.get_package, name)
			if not found then
				vim.notify("Unknown Mason package: " .. name, vim.log.levels.ERROR)
			elseif not pkg:is_installed() and not pkg:is_installing() then
				pkg:install()
			end
		end
	end)
end
function M.setup()
	vim.api.nvim_create_user_command(
		"NvimToolsInstall",
		M.install,
		{ desc = "Install declared missing tools explicitly", force = true }
	)
	vim.api.nvim_create_user_command("NvimParsersInstall", function()
		require("nvim-treesitter").install(require("configs.langs.treesitter"))
	end, { desc = "Install declared parsers explicitly", force = true })
end
return M
