local root = assert(vim.env.NVIM_RUST_TEST_ROOT)
local source = root .. "/src/main.rs"
local original = vim.fn.readfile(source)
local ready = false
require("rustaceanvim.config.internal").tools.on_initialized = function()
	ready = true
end
vim.cmd.edit(source)
assert(
	vim.wait(45000, function()
		return ready
	end, 100),
	"Rust project did not initialize"
)
vim.ui.select = Snacks.picker.select
local select_target = dofile(vim.env.NVIM_TEST_ROOT .. "/tests/rust/select.lua")
local dap = require("dap")
local buf = vim.api.nvim_get_current_buf()
vim.api.nvim_buf_set_lines(buf, 1, 2, false, { "    84" })
require("dap.breakpoints").set({}, buf, 9)
vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<F5>", true, false, true), "m", false)
local deadline = vim.uv.hrtime() + 60e9
local resumed = false
local function poll()
	local ok, err = pcall(function()
		select_target("debug")
		local session = dap.session()
		local frame = session and session.current_frame
		if frame and session.stopped_thread_id and frame.source and frame.source.path == source then
			if not resumed then
				resumed = true
				dap.continue()
			elseif frame.line == 9 then
				session:request(
					"evaluate",
					{ expression = "answer", context = "watch", frameId = frame.id },
					function(eval_err, result)
						if eval_err or not result or result.result ~= "84" then
							io.stderr:write("Rust F5 evaluation failed: " .. vim.inspect(eval_err or result) .. "\n")
							vim.cmd("cquit 1")
							return
						end
						dap.terminate()
						vim.fn.writefile(original, source)
						vim.defer_fn(function()
							io.stdout:write(
								"PASS: actual Rust F5 saves edits, builds Cargo target, pauses in source and evaluates variable\n"
							)
							vim.cmd("qa!")
						end, 300)
					end
				)
				return
			end
		end
		assert(vim.uv.hrtime() < deadline, "Rust F5 debug timed out")
		vim.defer_fn(poll, 50)
	end)
	if not ok then
		io.stderr:write(tostring(err) .. "\n")
		vim.cmd("cquit 1")
	end
end
vim.defer_fn(poll, 50)
