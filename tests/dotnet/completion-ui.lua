-- Exercise typed input and Blink's actual menu, not only a direct LSP request.
vim.o.columns = 140
vim.o.lines = 45
vim.cmd.cd(vim.env.NVIM_DOTNET_TEST_ROOT .. "/BlazorSmoke")
vim.cmd.edit("Components/Pages/Audit.razor")
vim.api.nvim_exec_autocmds("User", { pattern = "VeryLazy" })
local buf = vim.api.nvim_get_current_buf()
assert(
	vim.wait(45000, function()
		for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf, name = "easy_dotnet" })) do
			if require("easy-dotnet.roslyn.lsp").solution_loaded[client.id] then
				return true
			end
		end
	end, 100),
	"Roslyn did not load"
)
vim.api.nvim_buf_set_lines(buf, 4, 5, false, { "", "" })
vim.api.nvim_win_set_cursor(0, { 5, 0 })
local cmp = require("blink.cmp")
local results, stage, attempts = {}, "tags", 0
local function poll()
	attempts = attempts + 1
	local items, found = {}, false
	local wanted = stage == "tags" and "div" or "class"
	for _, item in ipairs(cmp.get_items()) do
		items[#items + 1] = { label = item.label, client = item.client_name, source = item.source_id }
		if item.label == wanted and item.client_name == "easy_dotnet" then
			found = true
		end
	end
	if found and cmp.is_menu_visible() then
		results[stage] = { visible = true, line = vim.api.nvim_get_current_line(), items = items }
		if stage == "tags" then
			stage, attempts = "attributes", 0
			vim.api.nvim_input(" ")
		else
			vim.fn.writefile({ vim.json.encode(results) }, vim.env.NVIM_DOTNET_TEST_OUTPUT .. "/completion-ui.json")
			print("PASS: typed Razor HTML tags and attributes open Blink with Roslyn suggestions")
			vim.cmd("qa!")
			return
		end
	elseif attempts >= 150 then
		io.stderr:write("Razor Blink menu missing " .. wanted .. " after typed input\n")
		vim.cmd("cquit 1")
		return
	end
	vim.defer_fn(poll, 100)
end
vim.api.nvim_input("i")
vim.defer_fn(function()
	vim.api.nvim_input("<LT>div")
	vim.defer_fn(poll, 100)
end, 100)
