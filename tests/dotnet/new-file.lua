local root = vim.env.NVIM_DOTNET_TEST_ROOT .. "/BlazorSmoke"
vim.cmd.cd(root)
local file = root .. "/Components/Pages/NewAuditSecond.razor"
assert(not vim.uv.fs_stat(file), "Fixture already exists: " .. file)
vim.cmd.edit(file)
local buf = vim.api.nvim_get_current_buf()
vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
	'@page "/new-audit"',
	"<p>@Value</p>",
	"@code {",
	"    private int Value = 42;",
	"}",
})
vim.cmd.write()
local ready = vim.wait(45000, function()
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf, name = "easy_dotnet" })) do
		if require("easy-dotnet.roslyn.lsp").solution_loaded[client.id] then
			return true
		end
	end
end, 100)
vim.fn.writefile(
	{ vim.json.encode({ attached_after_first_save = ready, filetype = vim.bo[buf].filetype }) },
	vim.env.NVIM_DOTNET_TEST_OUTPUT .. "/new-file.json"
)
assert(ready, "New Razor file did not attach after first save")
