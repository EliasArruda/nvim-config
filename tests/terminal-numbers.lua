local manager = require("core.terminals")
manager.toggle()
manager.new_split()
local list = vim.tbl_filter(function(t)
	return t.cmd == nil
end, Snacks.terminal.list())
table.sort(list, function(a, b)
	return a.buf < b.buf
end)
local function fail(message)
	io.stderr:write(message .. "\n")
	vim.cmd("cquit 1")
end
vim.defer_fn(function()
	vim.api.nvim_input("<M-1>")
	vim.defer_fn(function()
		if vim.api.nvim_get_current_buf() ~= list[1].buf then
			fail("Alt+1 did not select first shell in terminal mode")
			return
		end
		vim.api.nvim_input("<M-2>")
		vim.defer_fn(function()
			if vim.api.nvim_get_current_buf() ~= list[2].buf then
				fail("Alt+2 did not select second shell in terminal mode")
				return
			end
			vim.cmd.stopinsert()
			vim.defer_fn(function()
				for _, win in ipairs(vim.api.nvim_list_wins()) do
					if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "terminal_sessions" then
						vim.api.nvim_set_current_win(win)
					end
				end
				vim.api.nvim_input("<M-1>")
				vim.defer_fn(function()
					if vim.api.nvim_get_current_buf() ~= list[1].buf then
						fail("Alt+1 did not select shell from sidebar")
						return
					end
					manager.toggle()
					for _, terminal in ipairs(list) do
						vim.api.nvim_chan_send(vim.b[terminal.buf].terminal_job_id, "exit\n")
					end
					vim.wait(3000, function()
						return #Snacks.terminal.list() == 0
					end)
					io.stdout:write("PASS: actual Alt+1/Alt+2 terminal input and Alt+1 sidebar input\n")
					vim.cmd("qa!")
				end, 100)
			end, 50)
		end, 100)
	end, 100)
end, 100)
