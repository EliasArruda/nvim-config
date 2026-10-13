require("lazy").load({ plugins = { "nvim-autopairs" } })
local cases = {
	{ line = "<div></div>", col = 5, expected = { "<div>", "    ", "</div>" }, cursor = { 2, 4 } },
	{ line = "    <div></div>", col = 9, expected = { "    <div>", "        ", "    </div>" }, cursor = { 2, 8 } },
	{
		line = '<section class="box"></section>',
		col = 21,
		expected = { '<section class="box">', "    ", "</section>" },
		cursor = { 2, 4 },
	},
	{
		line = "<My.Widget></My.Widget>",
		col = 11,
		expected = { "<My.Widget>", "    ", "</My.Widget>" },
		cursor = { 2, 4 },
	},
}
local index = 0
local function fail(error)
	io.stderr:write(error .. "\n")
	vim.cmd("cquit 1")
end
local next_case
next_case = function()
	index = index + 1
	local case = cases[index]
	if not case then
		vim.cmd.stopinsert()
		vim.api.nvim_buf_set_lines(0, 0, -1, false, { '@code { string s = "<div></div>"; }' })
		vim.api.nvim_win_set_cursor(0, { 1, vim.api.nvim_get_current_line():find("</div>", 1, true) - 1 })
		if require("config.razor-editing").between_tags() then
			fail("C# string must not use HTML Enter")
			return
		end
		print("PASS: four actual Razor Enter cases and C# string exclusion")
		vim.cmd("qa!")
		return
	end
	vim.cmd.stopinsert()
	vim.cmd.enew({ bang = true })
	vim.bo.filetype, vim.bo.expandtab, vim.bo.shiftwidth = "razor", true, 4
	vim.api.nvim_buf_set_lines(0, 0, -1, false, { case.line })
	vim.api.nvim_win_set_cursor(0, { 1, case.col })
	vim.cmd.startinsert()
	vim.defer_fn(function()
		vim.api.nvim_input("<CR>")
		vim.defer_fn(function()
			local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
			local cursor = vim.api.nvim_win_get_cursor(0)
			if not vim.deep_equal(lines, case.expected) or not vim.deep_equal(cursor, case.cursor) then
				fail(vim.inspect({ case = case, lines = lines, cursor = cursor }))
				return
			end
			if index == 1 then
				vim.api.nvim_input("<Esc>u")
				vim.defer_fn(function()
					if not vim.deep_equal(vim.api.nvim_buf_get_lines(0, 0, -1, false), { case.line }) then
						fail("Undo must restore the original empty tag pair")
						return
					end
					next_case()
				end, 100)
				return
			end
			vim.cmd.stopinsert()
			vim.defer_fn(next_case, 50)
		end, 100)
	end, 100)
end
next_case()
