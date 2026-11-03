local root = assert(vim.env.NVIM_PYTHON_TEST_ROOT)
local mode = assert(vim.env.NVIM_PYTHON_CHECK)
vim.cmd.edit(root .. "/run.py")
vim.api.nvim_buf_set_lines(0, 0, -1, false, { "import sys", "print('PYTHON_OK', sys.prefix)" })
vim.cmd(mode == "run" and "PythonRun" or (mode == "pytest" and "PythonTest pytest" or "PythonTest"))
local timer = vim.uv.new_timer()
timer:start(
	100,
	100,
	vim.schedule_wrap(function()
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "terminal" then
				local text = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n")
				if
					(mode == "run" and text:find("PYTHON_OK " .. root .. "/.venv", 1, true))
					or (mode == "test" and text:find("Ran 1 test", 1, true) and text:find("OK", 1, true))
					or (mode == "pytest" and text:find("1 passed", 1, true))
				then
					timer:stop()
					timer:close()
					assert(not package.loaded.dap or not require("dap").session(), "Normal execution started debugger")
					vim.cmd.stopinsert()
					vim.api.nvim_buf_delete(buf, { force = true })
					vim.defer_fn(function()
						print("PASS: Python normal " .. mode .. " in project virtualenv")
						vim.cmd("qa!")
					end, 100)
					return
				end
			end
		end
	end)
)
vim.defer_fn(function()
	io.stderr:write("Python " .. mode .. " timeout\n")
	vim.cmd("cquit 1")
end, 20000)
