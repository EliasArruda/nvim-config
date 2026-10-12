-- Verify typed abbreviations, actual Tab acceptance, snippets, and Enter.
vim.o.columns, vim.o.lines = 140, 45
vim.cmd.cd(assert(vim.env.NVIM_BLAZOR_PROJECT_ROOT))
vim.cmd.edit("Components/Pages/EditProbe.razor")
vim.api.nvim_exec_autocmds("User", { pattern = "VeryLazy" })
local buf = vim.api.nvim_get_current_buf()
assert(
	vim.wait(15000, function()
		local client = vim.lsp.get_clients({ bufnr = buf, name = "emmet_language_server" })[1]
		return client and client.initialized
	end, 100),
	"Emmet language server did not initialize"
)
local cmp = require("blink.cmp")
local cases = {
	{ text = "span", expected = { "<span></span>" }, split = true },
	{ text = "span.", expected = { '<span class=""></span>' } },
	{ text = "div.container", expected = { '<div class="container"></div>' } },
	{ text = "ul>li*3", list = true },
}
local results, index = {}, 0
local function fail(message)
	vim.fn.writefile({ vim.json.encode(results) }, vim.env.NVIM_BLAZOR_TEST_OUTPUT .. "/emmet.json")
	io.stderr:write(message .. "\n")
	vim.cmd("cquit 1")
end
local next_case
next_case = function()
	index = index + 1
	local case = cases[index]
	if not case then
		vim.fn.writefile({ vim.json.encode(results) }, vim.env.NVIM_BLAZOR_TEST_OUTPUT .. "/emmet.json")
		print("PASS: four Emmet abbreviations, actual Tab acceptance, and two-line Enter")
		vim.cmd("qa!")
		return
	end
	cmp.hide()
	vim.snippet.stop()
	vim.cmd.stopinsert()
	vim.defer_fn(function()
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "" })
		vim.api.nvim_win_set_cursor(0, { 1, 0 })
		vim.cmd.startinsert()
		vim.defer_fn(function()
			vim.api.nvim_input(case.text)
			local attempts = 0
			local function poll()
				attempts = attempts + 1
				local first = cmp.get_items()[1]
				if
					cmp.is_menu_visible()
					and first
					and first.client_name == "emmet_language_server"
					and first.label == case.text
				then
					vim.api.nvim_input("<Tab>")
					vim.defer_fn(function()
						local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
						results[case.text] = { expanded = lines, cursor = vim.api.nvim_win_get_cursor(0) }
						local valid = case.list and #lines == 5 and lines[1] == "<ul>" and lines[5] == "</ul>"
						if case.list and valid then
							for row = 2, 4 do
								valid = valid and lines[row]:match("^%s*<li></li>$") ~= nil
							end
						end
						if case.expected then
							valid = vim.deep_equal(lines, case.expected)
						end
						if not valid then
							fail("Wrong Emmet expansion for " .. case.text)
							return
						end
						if case.split then
							vim.api.nvim_input("<CR>")
							vim.defer_fn(function()
								results[case.text].enter = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
								results[case.text].cursor_enter = vim.api.nvim_win_get_cursor(0)
								if
									not vim.deep_equal(results[case.text].enter, { "<span>", "</span>" })
									or not vim.deep_equal(results[case.text].cursor_enter, { 2, 0 })
								then
									fail("Enter must produce exactly two lines with cursor before closing tag")
									return
								end
								next_case()
							end, 200)
						else
							next_case()
						end
					end, 200)
				elseif attempts >= 100 then
					results[case.text] = {
						first = first and { label = first.label, client = first.client_name },
						line = vim.api.nvim_get_current_line(),
						mode = vim.api.nvim_get_mode().mode,
						cursor = vim.api.nvim_win_get_cursor(0),
					}
					fail("Emmet suggestion not first for " .. case.text)
				else
					vim.defer_fn(poll, 100)
				end
			end
			vim.defer_fn(poll, 150)
		end, 100)
	end, 100)
end
next_case()
