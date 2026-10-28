local root = assert(vim.env.NVIM_RUST_TEST_ROOT)
local mode = vim.env.NVIM_RUST_RUN_MODE
local ready = false
require("rustaceanvim.config.internal").tools.on_initialized = function()
	ready = true
end
vim.cmd.edit(root .. "/src/main.rs")
assert(
	vim.wait(45000, function()
		return ready
	end, 100),
	"Rust project did not initialize"
)
vim.ui.select = Snacks.picker.select
local select_target = dofile(vim.env.NVIM_TEST_ROOT .. "/tests/rust/select.lua")
local exits = {}
vim.api.nvim_create_autocmd("TermClose", {
	callback = function(event)
		exits[event.buf] = vim.v.event.status
	end,
})
local original = vim.fn.readfile(root .. "/src/main.rs")
if mode == "run" then
	vim.api.nvim_buf_set_lines(0, 1, 2, false, { "    84" })
else
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	for i, line in ipairs(lines) do
		lines[i] =
			line:gsub("fn answer_value_returns_forty_two%(", "fn answer_value_returns_forty_two_saved_before_run(")
	end
	vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
end
vim.cmd(mode == "test" and "CargoTest" or "CargoRun")
local deadline = vim.uv.hrtime() + 45e9
local function poll()
	local ok, err = pcall(function()
		select_target(mode)
		assert(not require("dap").session(), "Normal Rust command started debugger")
		for _, term in ipairs(Snacks.terminal.list()) do
			if exits[term.buf] ~= nil then
				local text = table.concat(vim.api.nvim_buf_get_lines(term.buf, 0, -1, false), "\n")
				assert(exits[term.buf] == 0, text)
				assert(text:find(mode == "test" and "test result: ok" or "Rust OK: 84", 1, true), text)
				assert(term:win_valid(), "Rust output terminal disappeared")
				if mode == "test" then
					assert(text:find("saved_before_run", 1, true), "CargoTest did not save edits")
				end
				vim.fn.writefile(original, root .. "/src/main.rs")
				vim.cmd.stopinsert()
				term:close()
				vim.defer_fn(function()
					io.stdout:write("PASS: Rust " .. mode .. " in persistent terminal without debugger\n")
					vim.cmd("qa!")
				end, 100)
				return
			end
		end
		assert(vim.uv.hrtime() < deadline, "Rust terminal command timed out")
		vim.defer_fn(poll, 50)
	end)
	if not ok then
		io.stderr:write(tostring(err) .. "\n")
		vim.cmd("cquit 1")
	end
end
vim.defer_fn(poll, 50)
