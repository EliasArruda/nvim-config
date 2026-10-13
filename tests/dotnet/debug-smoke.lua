vim.o.columns = 140
vim.o.lines = 45
local root = vim.env.NVIM_DOTNET_TEST_ROOT
vim.cmd.cd(root)
vim.cmd.edit(root .. "/BlazorSmoke/Program.cs")
vim.api.nvim_exec_autocmds("User", { pattern = "VeryLazy" })
local dap = require("dap")
local r = {}
require("easy-dotnet.current_solution").set_solution(root .. "/BlazorSmoke.slnx")
local picker = require("easy-dotnet.picker")
picker.picker = function(_, items, callback)
	for _, item in ipairs(items) do
		local name = tostring(item.display or item.name or "")
		if name:find("BlazorSmoke") and not name:find("Tests") then
			callback(item)
			return
		end
	end
	if #items == 1 then
		callback(items[1])
	else
		r.picker_items = vim.inspect(items)
	end
end
vim.api.nvim_win_set_cursor(0, { 4, 0 })
dap.toggle_breakpoint()
dap.listeners.after.event_initialized.audit = function()
	r.initialized = true
end
dap.listeners.after.event_stopped.audit = function(_, body)
	r.stopped = body
end
local ok, err = pcall(vim.cmd, "Dotnet debug default")
r.command_ok = ok
r.error = not ok and tostring(err) or nil
r.completed = vim.wait(60000, function()
	return r.stopped ~= nil
end, 100)
r.stack_ready = vim.wait(10000, function()
	local session = dap.session()
	local thread = session and r.stopped and session.threads[r.stopped.threadId]
	return thread and thread.frames and #thread.frames > 0
end, 50)
r.session = dap.session() ~= nil
r.messages = vim.api.nvim_exec2("messages", { output = true }).output
r.buffers = {}
for _, b in ipairs(vim.api.nvim_list_bufs()) do
	if vim.bo[b].buftype == "terminal" then
		r.buffers[#r.buffers + 1] = vim.api.nvim_buf_get_lines(b, 0, -1, false)
	end
end
if dap.session() then
	dap.terminate()
	vim.wait(2000, function()
		return dap.session() == nil
	end, 100)
end
vim.fn.writefile({ vim.json.encode(r) }, vim.env.NVIM_DOTNET_TEST_OUTPUT .. "/debug-smoke.json")

assert(
	r.completed and r.initialized and r.stack_ready and r.stopped.reason == "breakpoint",
	"Managed breakpoint failed"
)
