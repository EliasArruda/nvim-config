local root = vim.env.NVIM_DOTNET_TEST_ROOT .. "/BlazorSmoke"
vim.cmd.cd(root)
vim.cmd.edit(root .. "/Components/Pages/Audit.razor")
local buf = vim.api.nvim_get_current_buf()
vim.api.nvim_exec_autocmds("User", { pattern = "VeryLazy" })
local client
local r = {}
r.ready = vim.wait(45000, function()
	for _, c in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
		if c.name == "easy_dotnet" and c.initialized then
			client = c
			return require("easy-dotnet.roslyn.lsp").solution_loaded[c.id] == true
		end
	end
end, 100)
local function request(method, line, col, extra)
	local params = { textDocument = { uri = vim.uri_from_bufnr(buf) }, position = { line = line, character = col } }
	for k, v in pairs(extra or {}) do
		params[k] = v
	end
	local result, done
	if client then
		client:request(method, params, function(err, value)
			result = { err = err, result = value }
			done = true
		end, buf)
	end
	vim.wait(15000, function()
		return done
	end, 50)
	return result or { timeout = true }
end
if client then
	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	r.html_completion = request("textDocument/completion", 6, 8, { context = { triggerKind = 1 } })
	r.csharp_completion = request(
		"textDocument/completion",
		11,
		lines[12]:find("string.Empty", 1, true) + 6,
		{ context = { triggerKind = 1 } }
	)
	r.hover = request("textDocument/hover", 5, 14)
	r.definition = request("textDocument/definition", 5, 15)
	r.formatting = request("textDocument/formatting", 0, 0, { options = { tabSize = 4, insertSpaces = true } })
	r.symbols = request("textDocument/documentSymbol", 0, 0)
	r.semantic = request("textDocument/semanticTokens/full", 0, 0)
	r.rename = request("textDocument/rename", 10, 18, { newName = "renamedCount" })
	vim.api.nvim_buf_set_lines(buf, 10, 11, false, { '    private int currentCount = "invalid";' })
	r.error_seen = vim.wait(15000, function()
		for _, d in ipairs(vim.diagnostic.get(buf)) do
			if tostring(d.code) == "CS0029" or d.message:find("Cannot implicitly convert") then
				return true
			end
		end
	end, 100)
	r.diagnostics = vim.diagnostic.get(buf)
	r.diagnostic_request = request("textDocument/diagnostic", 0, 0)
	vim.api.nvim_buf_set_lines(buf, 10, 11, false, { lines[11] })
end
local p = vim.treesitter.get_parser(buf)
local ts = p:parse(true)
r.tree_error = ts[1]:root():has_error()
r.html_documents = vim.tbl_count(require("easy-dotnet.razor.html").documents)
r.clients = {}
for _, c in ipairs(vim.lsp.get_clients()) do
	r.clients[#r.clients + 1] = { name = c.name, initialized = c.initialized }
end
r.messages = vim.api.nvim_exec2("messages", { output = true }).output
vim.fn.writefile({ vim.json.encode(r) }, vim.env.NVIM_DOTNET_TEST_OUTPUT .. "/razor-features.json")

assert(r.ready and r.error_seen and not r.tree_error, "Razor initialization/diagnostic/parser failed")
for _, key in ipairs({ "html_completion", "csharp_completion", "hover", "definition", "symbols", "rename" }) do
	assert(r[key] and r[key].result and not r[key].err, key .. " failed")
end
