local template_group = vim.api.nvim_create_augroup("VueFileTemplates", { clear = true })

local function is_buffer_empty()
	local line_count = vim.api.nvim_buf_line_count(0)
	if line_count > 1 then
		return false
	end
	local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] or ""
	return first_line:match("^%s*$") ~= nil
end

local function apply_template(template, cursor_line, cursor_col)
	vim.api.nvim_buf_set_lines(0, 0, -1, false, template)

	vim.schedule(function()
		local line_count = vim.api.nvim_buf_line_count(0)
		local safe_line = math.min(cursor_line, line_count)
		vim.api.nvim_win_set_cursor(0, { safe_line, cursor_col })
		if vim.g.vscode then
			vim.cmd("startinsert!")
		else
			vim.cmd("startinsert")
		end
	end)
end

local function run_template()
	vim.schedule(function()
		local filename = vim.fn.expand("%:t")

		if filename == "" or not filename:match("%.vue$") then
			return
		end
		if not is_buffer_empty() then
			return
		end

		local template = {
			"<template>",
			"  ",
			"</template>",
		}

		apply_template(template, 2, 2)
	end)
end

vim.api.nvim_create_autocmd("BufNewFile", {
	pattern = "*.vue",
	group = template_group,
	callback = run_template,
})
