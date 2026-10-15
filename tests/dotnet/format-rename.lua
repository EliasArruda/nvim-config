local root = vim.env.NVIM_DOTNET_TEST_ROOT
vim.cmd.cd(root)
vim.cmd.edit(root .. "/BlazorSmoke/Components/Pages/Audit.razor")
vim.api.nvim_exec_autocmds("User", { pattern = "VeryLazy" })
local buf = vim.api.nvim_get_current_buf()
local client
local r = {}
r.ready = vim.wait(45000, function()
	for _, c in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
		if c.name == "easy_dotnet" and require("easy-dotnet.roslyn.lsp").solution_loaded[c.id] then
			client = c
			return true
		end
	end
end, 100)
local function req(method, params)
	local result, done
	client:request(method, params, function(e, v)
		result = { err = e, result = v }
		done = true
	end, buf)
	vim.wait(15000, function()
		return done
	end, 30)
	return result or { timeout = true }
end
if client then
	r.format_supported = client:supports_method("textDocument/formatting", buf)
	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	vim.api.nvim_buf_set_lines(buf, 12, 13, false, { "private void IncrementCount(){currentCount++;}" })
	vim.wait(600)
	r.format = req(
		"textDocument/formatting",
		{ textDocument = { uri = vim.uri_from_bufnr(buf) }, options = { tabSize = 4, insertSpaces = true } }
	)
	r.format_range = req(
		"textDocument/rangeFormatting",
		{
			textDocument = { uri = vim.uri_from_bufnr(buf) },
			range = { start = { line = 0, character = 0 }, ["end"] = { line = #lines - 1, character = #lines[#lines] } },
			options = { tabSize = 4, insertSpaces = true },
		}
	)
	if r.format.result and #r.format.result > 0 then
		vim.lsp.util.apply_text_edits(r.format.result, buf, client.offset_encoding)
	end
	r.formatted = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.wait(300)
	r.rename = req(
		"textDocument/rename",
		{ textDocument = { uri = vim.uri_from_bufnr(buf) }, position = { line = 10, character = 18 }, newName = "renamedCount" }
	)
	if r.rename.result then
		vim.lsp.util.apply_workspace_edit(r.rename.result, client.offset_encoding)
	end
	r.renamed = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	-- Exercise a completion item resolve, including Razor's server-side data.
	local completion = req(
		"textDocument/completion",
		{ textDocument = { uri = vim.uri_from_bufnr(buf) }, position = { line = 11, character = 35 }, context = {
			triggerKind = 1,
		} }
	)
	if completion.result then
		local list = completion.result
		local item = (list.items or list)[1]
		if item then
			if not item.data and list.itemDefaults then
				item.data = list.itemDefaults.data
			end
			r.resolve = req("completionItem/resolve", item)
		end
	end
end
r.messages = vim.api.nvim_exec2("messages", { output = true }).output
vim.fn.writefile({ vim.json.encode(r) }, vim.env.NVIM_DOTNET_TEST_OUTPUT .. "/format-rename.json")

assert(r.ready and r.format.result and #r.format.result > 0, "Razor formatting failed")
assert(table.concat(r.renamed, "\n"):find("renamedCount", 1, true), "Razor rename failed")
assert(r.resolve and r.resolve.result, "Completion resolve failed")
