local root = assert(vim.env.NVIM_CPP_TEST_ROOT)
local mode = vim.env.NVIM_CPP_F5_MODE
local standalone = mode == "standalone" or mode == "error" or mode == "ui"
local multiple = mode == "multiple"
local build_failed = false
if mode == "error" then
	local notify = vim.notify
	vim.notify = function(message, ...)
		if tostring(message):find("C/C++ build failed", 1, true) then
			build_failed = true
		end
		notify(message, ...)
	end
end
local file
if standalone then
	root = root .. "-" .. mode
	vim.fn.mkdir(root, "p")
	file = root .. "/main.cpp"
	vim.fn.writefile({ "int main() {", "  int answer = 42;", "  return answer == 42 ? 0 : 1;", "}" }, file)
else
	if multiple then
		local original = root
		root = root .. "-multiple"
		vim.fn.mkdir(root .. "/include", "p")
		for _, name in ipairs({ "main.cpp", "include/sample.hpp", "CMakeLists.txt" }) do
			vim.fn.writefile(vim.fn.readfile(original .. "/" .. name), root .. "/" .. name)
		end
		vim.fn.writefile({
			"add_executable(cpp-second main.cpp)",
			"target_include_directories(cpp-second PRIVATE include)",
			"target_compile_definitions(cpp-second PRIVATE FROM_COMPDB=42)",
		}, root .. "/CMakeLists.txt", "a")
		vim.ui.select = function(items, _, callback)
			for _, item in ipairs(items) do
				if item.name == "cpp-second" then
					callback(item)
					return
				end
			end
			error("Second CMake executable not offered")
		end
	end
	file = root .. "/main.cpp"
	vim.fn.delete(root .. "/build/cpp-smoke")
end
if mode == "error" then
	vim.fn.writefile({ "int main() { missing_symbol; }" }, file)
end
vim.cmd.cd(root)
vim.cmd.edit(file)
assert(not package.loaded.dap or not package.loaded.dap.session(), "Debug session existed before first F5")
-- Dispatch the actual F5 mapping in a fresh editor session.
vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<F5>", true, false, true), "m", false)
local deadline = vim.uv.hrtime() + 45e9
local configured = false
local reason
local resumed_start = false
local function poll()
	local ok, err = pcall(function()
		local dap = package.loaded.dap
		if mode == "error" and build_failed then
			assert(not dap.session(), "Failed build launched a debugger")
			assert(#vim.fn.getqflist() > 0, "Build failure did not populate quickfix")
			io.stdout:write("PASS: F5 build error populates quickfix and aborts debug launch\n")
			vim.cmd("qa!")
			return
		end
		if dap and not configured then
			configured = true
			local line = standalone and 3 or 6
			dap.listeners.after.event_stopped.cpp_f5 = function(_, event)
				reason = event.reason
			end
			if mode ~= "ui" then
				require("dap.breakpoints").set({}, vim.fn.bufnr(file), line)
			end
			if mode == "switch" then
				vim.fn.mkdir(root .. "-other", "p")
				vim.fn.writefile({ "all:" }, root .. "-other/Makefile")
				vim.fn.writefile({ "int main() { return 0; }" }, root .. "-other/other.cpp")
				vim.cmd.edit(root .. "-other/other.cpp")
			end
		end
		if dap and dap.session() and dap.session().current_frame and reason and dap.session().stopped_thread_id then
			local session = dap.session()
			if mode == "ui" then
				local panels = {}
				for _, win in ipairs(vim.api.nvim_list_wins()) do
					panels[vim.bo[vim.api.nvim_win_get_buf(win)].filetype] = true
				end
				assert(
					panels.dapui_scopes and panels.dapui_watches and panels.dapui_stacks and panels.dapui_breakpoints,
					"Debug panels missing at entry"
				)
				assert(session.stopped_thread_id, "Program did not pause on entry")
				assert(session.current_frame.source.path == file, "Initial pause is outside user source")
				dap.terminate()
				vim.defer_fn(function()
					io.stdout:write("PASS: F5 without breakpoints pauses at entry and opens debug panels\n")
					vim.cmd("qa!")
				end, 300)
				return
			end
			if not resumed_start then
				resumed_start = true
				reason = nil
				dap.continue()
				vim.defer_fn(poll, 50)
				return
			end
			if session.current_frame.line ~= (standalone and 3 or 6) then
				vim.defer_fn(poll, 50)
				return
			end
			assert(session.config.cwd == root, "Debug cwd changed while building")
			session:request(
				"evaluate",
				{ expression = "answer", context = "watch", frameId = session.current_frame.id },
				function(eval_err, result)
					if eval_err or not result or result.result ~= "42" then
						io.stderr:write("F5 evaluation failed: " .. vim.inspect(eval_err or result) .. "\n")
						vim.cmd("cquit 1")
						return
					end
					if multiple then
						assert(session.config.program:find("cpp-second", 1, true), "Selected CMake target ignored")
					end
					assert(vim.fn.executable(session.config.program) == 1, "Automatic build did not create executable")
					dap.terminate()
					vim.defer_fn(function()
						io.stdout:write("PASS: cold F5 builds, launches and hits native breakpoint (" .. mode .. ")\n")
						vim.cmd("qa!")
					end, 300)
				end
			)
			return
		end
		assert(vim.uv.hrtime() < deadline, "F5 build/debug timed out")
		vim.defer_fn(poll, 50)
	end)
	if not ok then
		io.stderr:write(tostring(err) .. "\n")
		vim.cmd("cquit 1")
	end
end
vim.defer_fn(poll, 50)
