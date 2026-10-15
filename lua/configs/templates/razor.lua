vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost", "BufEnter" }, {
	group = vim.api.nvim_create_augroup("RazorFileTemplates", { clear = true }),
	pattern = "*.razor",
	callback = function(event)
		if not require("configs.templates.common").eligible(event) then
			return
		end
		local path = vim.api.nvim_buf_get_name(event.buf)
		local name = vim.fn.fnamemodify(path, ":t:r")
		if name:sub(1, 1) == "_" then
			return
		end
		vim.defer_fn(function()
			if
				vim.api.nvim_get_current_buf() ~= event.buf or not require("configs.templates.common").eligible(event)
			then
				return
			end
			local lines = {
				"<h3>" .. name:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;") .. "</h3>",
				"",
				"@code {",
				"    ",
				"}",
			}
			vim.api.nvim_buf_set_lines(event.buf, 0, -1, false, lines)
			vim.api.nvim_win_set_cursor(0, { 4, 4 })
			vim.cmd.startinsert()
		end, vim.g.vscode and 200 or 0)
	end,
})
