local root = assert(vim.env.NVIM_CPP_TEST_ROOT)
vim.cmd.cd(root)
vim.cmd.edit(root .. "/main.cpp")
local buf = vim.api.nvim_get_current_buf()
local client
assert(
	vim.wait(20000, function()
		client = vim.lsp.get_clients({ bufnr = buf, name = "clangd" })[1]
		return client and client.initialized
	end, 50),
	"clangd did not attach"
)
assert(client.config.root_dir == root, "Wrong C++ project root")
assert(vim.bo.filetype == "cpp", "Wrong C++ filetype")
assert(vim.treesitter.get_parser(buf, "cpp"):parse()[1], "C++ parser unavailable")
local function request(method, params)
	local response, err = client:request_sync(method, params, 10000, buf)
	assert(response and not response.err, vim.inspect(response or err))
	return response.result
end
local uri = vim.uri_from_bufnr(buf)
local function position(line, token)
	local text = vim.api.nvim_buf_get_lines(buf, line, line + 1, false)[1]
	return {
		textDocument = { uri = uri },
		position = { line = line, character = assert(text:find(token, 1, true)) - 1 },
	}
end
local hover = request("textDocument/hover", position(3, "answer_value"))
assert(hover and hover.contents, "C++ hover missing")
local definition = request("textDocument/definition", position(3, "answer_value"))
assert(definition and #definition > 0, "Header definition missing")
local completion = position(5, "front")
completion.context = { triggerKind = 2, triggerCharacter = "." }
local items = request("textDocument/completion", completion)
local found = false
for _, item in ipairs(items.items or items) do
	if item.label:find("size", 1, true) then
		found = true
	end
end
assert(found, "std::vector member completion missing")
assert(
	vim.wait(10000, function()
		return vim.lsp.status() == ""
	end, 50),
	"clangd stayed busy"
)
for _, diagnostic in ipairs(vim.diagnostic.get(buf)) do
	assert(diagnostic.severity ~= vim.diagnostic.severity.ERROR, diagnostic.message)
end
vim.api.nvim_buf_set_lines(buf, 5, 5, false, { "  int broken = missing_symbol;" })
assert(
	vim.wait(10000, function()
		for _, d in ipairs(vim.diagnostic.get(buf)) do
			if d.message:find("missing_symbol", 1, true) then
				return true
			end
		end
	end, 50),
	"C++ error diagnostic missing"
)
vim.api.nvim_buf_set_lines(buf, 5, 6, false, {})
local rename = position(3, "answer =")
rename.newName = "result"
local edit = request("textDocument/rename", rename)
assert(edit and (edit.changes or edit.documentChanges), "C++ rename edits missing")
vim.lsp.util.apply_workspace_edit(edit, client.offset_encoding)
assert(
	table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n"):find("const int result", 1, true),
	"C++ rename did not update declaration"
)
vim.api.nvim_buf_set_lines(buf, 2, 3, false, { "int main(){" })
require("conform").format({ bufnr = buf, async = false, timeout_ms = 5000 })
assert(require("conform").get_formatter_info("clang_format", buf).available, "clang-format unavailable")
assert(
	table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n"):find("int main() {", 1, true),
	"clang-format did not format buffer"
)
-- Use original disk source for the breakpoint, independent of formatter output.
vim.cmd("edit!")
require("lazy").load({ plugins = { "nvim-dap" } })
local dap = require("dap")
vim.api.nvim_win_set_cursor(0, { 6, 0 })
dap.toggle_breakpoint()
local config = vim.deepcopy(dap.configurations.cpp[1])
config.stopOnEntry = false
config.preRunCommands = {}
config.program = root .. "/build/cpp-smoke"
config.cwd = root
local stopped = false
dap.listeners.after.event_stopped.cpp_smoke = function()
	stopped = true
end
dap.run(config)
assert(
	vim.wait(20000, function()
		return stopped and dap.session() and dap.session().current_frame
	end, 50),
	"C++ breakpoint not reached"
)
local frame = dap.session().current_frame
local done, evaluated = false, nil
dap.session()
	:request("evaluate", { expression = "answer", context = "watch", frameId = frame.id }, function(err, result)
		evaluated = not err and result and result.result
		done = true
	end)
assert(
	vim.wait(5000, function()
		return done
	end, 50),
	"C++ evaluate timed out"
)
assert(evaluated == "42", "Debugger evaluated answer as " .. tostring(evaluated))
dap.listeners.after.event_stopped.cpp_smoke = nil
dap.terminate()
assert(
	vim.wait(5000, function()
		return dap.session() == nil
	end, 50),
	"Debugger did not terminate"
)
vim.fn.mkdir(root .. "/templates", "p")
for _, name in ipairs({ "main.cpp", "Shape.hpp", "Shape.cpp" }) do
	local path = root .. "/templates/" .. name
	vim.cmd.edit(path)
	assert(
		vim.wait(1000, function()
			return vim.api.nvim_buf_line_count(0) > 1
		end, 20),
		"Generated C++ template missing: " .. name
	)
	vim.cmd.stopinsert()
	vim.cmd.write()
	if name:match("%.cpp$") then
		local compile = vim.system({ "c++", "-fsyntax-only", path }, { text = true }):wait(10000)
		assert(compile.code == 0, compile.stderr)
	end
end
io.stdout:write(
	"PASS: C++ build/run, clangd root, parser, hover, header definition, STL completion, diagnostics, rename, formatter and native breakpoint/evaluate and compiled generated templates\n"
)
