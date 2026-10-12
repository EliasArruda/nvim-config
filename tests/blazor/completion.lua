-- Drive Insert mode and the actual Blink menu against a temporary Blazor project.
vim.o.columns, vim.o.lines = 140, 45
local root = assert(vim.env.NVIM_BLAZOR_PROJECT_ROOT)
vim.cmd.cd(root)
vim.cmd.edit(root .. "/Components/Pages/EditProbe.razor")
vim.api.nvim_exec_autocmds("User", { pattern = "VeryLazy" })
local buf = vim.api.nvim_get_current_buf()
assert(
	vim.wait(45000, function()
		for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf, name = "easy_dotnet" })) do
			if client.initialized and require("easy-dotnet.roslyn.lsp").solution_loaded[client.id] then
				return true
			end
		end
	end, 100),
	"Roslyn did not load the Blazor solution"
)
local cmp = require("blink.cmp")
local cases = {
	{ name = "html_tag", prefix = "", typed = "<LT>div", wanted = "div" },
	{ name = "html_attribute", prefix = "<div", typed = " ", wanted = "class" },
	{ name = "multiline_attribute", prefix = "  ", before = "<div", typed = " ", wanted = "class" },
	{ name = "component", prefix = "", typed = "<LT>AuditB", wanted = "AuditButton" },
	{ name = "component_attribute", prefix = "<AuditButton", typed = " ", wanted = "Text" },
	{ name = "csharp", prefix = "@code { string Value = string", typed = ".", wanted = "Empty" },
}
local results, index = {}, 0
local function save()
	vim.fn.writefile({ vim.json.encode(results) }, vim.env.NVIM_BLAZOR_TEST_OUTPUT .. "/completion.json")
end
local next_case
next_case = function()
	index = index + 1
	local case = cases[index]
	if not case then
		save()
		print("PASS: typed HTML, multiline attributes, Blazor component/parameter and C# completion")
		vim.cmd("qa!")
		return
	end
	cmp.hide()
	vim.cmd.stopinsert()
	vim.defer_fn(function()
		local lines = { '@page "/edit-probe"', "@using BlazorSmoke.Components", "" }
		if case.before then
			lines[#lines + 1] = case.before
		end
		lines[#lines + 1] = case.prefix
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
		vim.api.nvim_win_set_cursor(0, { #lines, #case.prefix })
		vim.cmd.startinsert({ bang = true })
		vim.defer_fn(function()
			vim.api.nvim_input(case.typed)
			local attempts = 0
			local function poll()
				attempts = attempts + 1
				local found, items = false, {}
				for _, item in ipairs(cmp.get_items()) do
					items[#items + 1] = { label = item.label, client = item.client_name }
					if item.label == case.wanted and item.client_name == "easy_dotnet" then
						found = true
					end
				end
				if found and cmp.is_menu_visible() then
					results[case.name] = { passed = true, line = vim.api.nvim_get_current_line(), items = items }
					next_case()
				elseif attempts >= 150 then
					results[case.name] = { passed = false, line = vim.api.nvim_get_current_line(), items = items }
					save()
					io.stderr:write("Completion missing " .. case.wanted .. " in " .. case.name .. "\n")
					vim.cmd("cquit 1")
				else
					vim.defer_fn(poll, 100)
				end
			end
			vim.defer_fn(poll, 150)
		end, 100)
	end, 100)
end
next_case()
