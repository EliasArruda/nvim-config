local root = assert(vim.env.NVIM_PYTHON_TEST_ROOT)
vim.cmd.edit(root .. "/debug.py")
require("lazy").load({ plugins = { "nvim-dap" } })
local dap = require("dap")
vim.api.nvim_buf_set_lines(0, 0, -1, false, { "answer = 84", "print(answer)", "print('done')" })
vim.api.nvim_win_set_cursor(0, { 2, 0 })
dap.toggle_breakpoint()
local stopped, evaluated = false, false
dap.listeners.after.event_stopped.python_check = function(_, event)
	if event.reason == "entry" then
		vim.defer_fn(function()
			dap.continue()
		end, 100)
	else
		stopped = true
		vim.defer_fn(function()
			dap.session():evaluate("answer", function(err, response)
				assert(not err and response.result == "84", vim.inspect(err or response))
				evaluated = true
				dap.terminate()
				vim.defer_fn(function()
					print("PASS: Python F5, save before debug, breakpoint, variable evaluation and DAP UI")
					vim.cmd("qa!")
				end, 500)
			end)
		end, 300)
	end
end
vim.api.nvim_feedkeys(vim.keycode("<F5>"), "m", false)
vim.defer_fn(function()
	if not evaluated then
		io.stderr:write("Python debug timeout: stopped=" .. tostring(stopped) .. "\n")
		vim.cmd("cquit 1")
	end
end, 45000)
