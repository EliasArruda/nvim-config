local M = {}

function M.interpreter(root, buf)
	buf = buf or vim.api.nvim_get_current_buf()
	root = root or require("core.project").root(buf)
	-- The selector restarts Pyright with the chosen interpreter for this project.
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf, name = "pyright" })) do
		local python = (client.config.settings or {}).python or {}
		if client.config.root_dir == root and python.pythonPath and vim.fn.executable(python.pythonPath) == 1 then
			return python.pythonPath
		end
	end
	for _, directory in ipairs({ ".venv", "venv", "env" }) do
		local path = root .. "/" .. directory .. "/bin/python"
		if vim.fn.executable(path) == 1 then
			return path
		end
	end
	for _, directory in ipairs({ vim.env.VIRTUAL_ENV or "", vim.env.CONDA_PREFIX or "" }) do
		if directory ~= "" and vim.fn.executable(directory .. "/bin/python") == 1 then
			return directory .. "/bin/python"
		end
	end
	return vim.fn.exepath("python3")
end

function M.run(test_runner)
	if vim.bo.filetype ~= "python" or vim.bo.buftype ~= "" then
		vim.notify("Open a Python file first", vim.log.levels.WARN)
		return
	end
	vim.cmd("silent update")
	local root = require("core.project").root()
	local command = { M.interpreter(root) }
	if test_runner then
		vim.list_extend(
			command,
			test_runner == "pytest" and { "-m", "pytest" } or { "-m", "unittest", "discover", "-v" }
		)
	else
		vim.list_extend(command, { "-u", vim.api.nvim_buf_get_name(0) })
	end
	require("snacks").terminal.open(command, {
		cwd = root,
		auto_close = false,
		win = { position = "bottom", height = 0.35 },
	})
end

function M.setup_dap(dap)
	-- Run the adapter from Mason; the debuggee uses the project's interpreter.
	dap.adapters.python = {
		type = "executable",
		command = vim.fn.stdpath("data") .. "/mason/bin/debugpy-adapter",
	}
	dap.configurations.python = {
		{
			name = "Python: current file",
			type = "python",
			request = "launch",
			program = "${file}",
			cwd = function()
				return require("core.project").root()
			end,
			pythonPath = function()
				return M.interpreter()
			end,
			console = "integratedTerminal",
			justMyCode = true,
			stopOnEntry = true,
		},
		{
			name = "Python: module",
			type = "python",
			request = "launch",
			module = function()
				return vim.fn.input("Python module (e.g. pytest): ")
			end,
			cwd = function()
				return require("core.project").root()
			end,
			pythonPath = function()
				return M.interpreter()
			end,
			console = "integratedTerminal",
			justMyCode = true,
		},
	}
end

function M.setup()
	vim.api.nvim_create_user_command("PythonRun", function()
		M.run()
	end, { desc = "Run the current Python file" })
	vim.api.nvim_create_user_command("PythonTest", function(opts)
		if opts.args ~= "" and opts.args ~= "pytest" and opts.args ~= "unittest" then
			vim.notify("Use :PythonTest [unittest|pytest]", vim.log.levels.ERROR)
			return
		end
		M.run(opts.args == "pytest" and "pytest" or "unittest")
	end, {
		nargs = "?",
		complete = function()
			return { "unittest", "pytest" }
		end,
		desc = "Run project Python tests",
	})
end

return M
