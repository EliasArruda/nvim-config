local root = assert(vim.env.NVIM_CPP_TEST_ROOT)
local mode = vim.env.NVIM_CPP_RUN_MODE
if mode == "standalone" or mode == "error" then
	root = root .. "-run-" .. mode
	vim.fn.mkdir(root, "p")
	vim.fn.writefile(mode == "error" and { "int main() { missing_symbol; }" } or {
		"#include <iostream>",
		'int main() { std::cout << "normal run OK" << std::endl; return 0; }',
	}, root .. "/main.cpp")
end
vim.cmd.cd(root)
vim.cmd.edit(root .. "/main.cpp")
local before = #Snacks.terminal.list()
local exits = {}
vim.api.nvim_create_autocmd("TermClose", {
	callback = function(event)
		exits[event.buf] = vim.v.event.status
	end,
})
local failed = false
local notify = vim.notify
vim.notify = function(message, ...)
	if tostring(message):find("C/C++ build failed", 1, true) then
		failed = true
	end
	notify(message, ...)
end
vim.cmd.CppRun()
local deadline = vim.uv.hrtime() + 30e9
local function poll()
	local ok, err = pcall(function()
		assert(not require("dap").session(), "CppRun started a debugger")
		if mode == "error" and failed then
			assert(#Snacks.terminal.list() == before, "Failed build started a terminal")
			assert(#vim.fn.getqflist() > 0, "Compiler errors missing")
			io.stdout:write("PASS: CppRun aborts on compiler errors without debugger/terminal\n")
			vim.cmd("qa!")
			return
		end
		for _, term in ipairs(Snacks.terminal.list()) do
			if term.cmd and vim.api.nvim_buf_is_valid(term.buf) then
				if exits[term.buf] ~= nil then
					local text = table.concat(vim.api.nvim_buf_get_lines(term.buf, 0, -1, false), "\n")

					assert(term:win_valid(), "Normal-run terminal closed on exit")
					if mode == "standalone" then
						assert(text:find("normal run OK", 1, true), "Program output missing")
					end
					assert(exits[term.buf] == 0, "Normal program exited with an error")
					io.stdout:write(
						"PASS: CppRun builds and runs in persistent terminal without debugger (" .. mode .. ")\n"
					)
					vim.cmd.stopinsert()
					term:close()
					vim.defer_fn(function() vim.cmd("qa!") end, 100)
					return
				end
			end
		end
		assert(vim.uv.hrtime() < deadline, "CppRun timed out")
		vim.defer_fn(poll, 50)
	end)
	if not ok then
		io.stderr:write(tostring(err) .. "\n")
		vim.cmd("cquit 1")
	end
end
vim.defer_fn(poll, 50)
