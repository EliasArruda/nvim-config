local root = assert(vim.env.NVIM_PYTHON_TEST_ROOT)
vim.cmd.edit(root .. "/main.py")
local buf = vim.api.nvim_get_current_buf()
local python = require("config.python")
assert(python.interpreter() == root .. "/.venv/bin/python", "Project virtualenv was not selected")
assert(require("core.project").root() == root, "Python project root incorrect")
local client
assert(
	vim.wait(30000, function()
		client = vim.lsp.get_clients({ bufnr = buf, name = "pyright" })[1]
		local ruff = vim.lsp.get_clients({ bufnr = buf, name = "ruff" })[1]
		return client and client.initialized and ruff and ruff.initialized
	end, 100),
	"Python LSPs did not attach"
)
assert(client.config.settings.python.pythonPath == root .. "/.venv/bin/python", "Pyright interpreter incorrect")
assert(vim.treesitter.get_parser(buf, "python"):parse()[1], "Python parser missing")
local uri = vim.uri_from_bufnr(buf)
assert(
	vim.wait(20000, function()
		local result = client:request_sync(
			"textDocument/hover",
			{ textDocument = { uri = uri }, position = { line = 3, character = 8 } },
			2000,
			buf
		)
		return result and result.result and result.result.contents
	end, 100),
	"Python hover unavailable"
)
local completion = client:request_sync(
	"textDocument/completion",
	{ textDocument = { uri = uri }, position = { line = 4, character = 11 } },
	10000,
	buf
)
assert(
	completion and completion.result and #(completion.result.items or completion.result) > 0,
	"Python completion missing"
)
assert(
	vim.wait(15000, function()
		for _, diagnostic in ipairs(vim.diagnostic.get(buf)) do
			if diagnostic.message:find("not assignable", 1, true) then
				return true
			end
		end
	end, 100),
	"Python type diagnostic missing"
)
local ruff = vim.lsp.get_clients({ bufnr = buf, name = "ruff" })[1]
assert(not ruff.server_capabilities.hoverProvider, "Ruff hover conflicts with Pyright")
vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "import sys", "import os", "", "answer= 42" })
require("conform").format({ bufnr = buf, async = false, timeout_ms = 10000 })
local text = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n")
assert(
	text:find("answer = 42", 1, true) and text:find("import os\nimport sys", 1, true),
	"Ruff format/import sort failed: " .. text
)
require("lazy").load({ plugins = { "nvim-dap" } })
local dap = require("dap")
assert(dap.configurations.python[1].pythonPath() == root .. "/.venv/bin/python", "Debugger interpreter incorrect")
assert(vim.fn.executable(dap.adapters.python.command) == 1, "debugpy adapter missing")
-- Selecting another environment must affect this buffer without changing other project roots.
local alternate = root .. "/other/bin/python"
require("venv-selector").activate_from_path(alternate, "venv")
assert(
	vim.wait(15000, function()
		return python.interpreter() == alternate
	end, 100),
	"Selected environment was not applied"
)
print("PASS: Python LSP, types, completion, parser, Ruff format/imports, virtualenv and debugger configuration")
vim.cmd("qa!")
