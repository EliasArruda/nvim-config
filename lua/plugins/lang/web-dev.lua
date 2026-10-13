local web_filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "css", "html", "mdx" }

local function project_root()
	return require("core.project").root()
end

local function package_manager(root)
	return require("core.project").package_manager(root)
end

local function run_script(script)
	local root = project_root()
	local manager = package_manager(root)
	local package_json = root .. "/package.json"
	local ok, package = pcall(function()
		return vim.json.decode(table.concat(vim.fn.readfile(package_json), "\n"))
	end)

	if not ok or type(package) ~= "table" or type(package.scripts) ~= "table" or not package.scripts[script] then
		vim.notify(("Script '%s' não existe em %s"):format(script, package_json), vim.log.levels.WARN)
		return
	end

	if vim.fn.executable(manager) == 0 then
		vim.notify("Package manager not found: " .. manager, vim.log.levels.ERROR)
		return
	end
	local command = { manager, "run", script }
	Snacks.terminal(command, { cwd = root, win = { position = "bottom", height = 0.35 } })
end

return {
	{
		"neovim/nvim-lspconfig",
		ft = web_filetypes,
		keys = {
			{
				"<leader>co",
				function()
					vim.lsp.buf.code_action({
						context = { only = { "source.organizeImports" }, diagnostics = {} },
						apply = true,
					})
				end,
				desc = "Organize imports",
			},
			{
				"<leader>cE",
				function()
					vim.lsp.buf.code_action({
						context = { only = { "source.fixAll.eslint" }, diagnostics = {} },
						apply = true,
					})
				end,
				desc = "ESLint: fix all",
			},
		},
	},
	{
		"folke/snacks.nvim",
		keys = {
			{
				"<leader>rpd",
				function()
					run_script("dev")
				end,
				desc = "Project: dev",
			},
			{
				"<leader>rpb",
				function()
					run_script("build")
				end,
				desc = "Project: build",
			},
			{
				"<leader>rpt",
				function()
					run_script("test")
				end,
				desc = "Project: test",
			},
			{
				"<leader>rpl",
				function()
					run_script("lint")
				end,
				desc = "Project: lint",
			},
			{
				"<leader>rpc",
				function()
					run_script("typecheck")
				end,
				desc = "Project: typecheck",
			},
		},
	},
}
