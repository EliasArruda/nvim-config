vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost", "BufEnter" }, {
	group = vim.api.nvim_create_augroup("PythonFileTemplates", { clear = true }),
	pattern = "*.py",
	callback = function(event)
		local common = require("configs.templates.common")
		if not common.eligible(event) then
			return
		end
		vim.defer_fn(function()
			if vim.api.nvim_get_current_buf() ~= event.buf or not common.eligible(event) then
				return
			end
			local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(event.buf), ":t")
			-- Package initializers stay empty; importing a package must have no side effects.
			if name == "__init__.py" then
				return
			end
			local main = name == "main.py" or name == "__main__.py"
			local lines = main
					and {
						"def main() -> None:",
						'    print("Hello, world!")',
						"",
						"",
						'if __name__ == "__main__":',
						"    main()",
					}
				or { '"""Module documentation."""', "", "" }
			vim.api.nvim_buf_set_lines(event.buf, 0, -1, false, lines)
			vim.api.nvim_win_set_cursor(0, { main and 2 or 3, main and 4 or 0 })
			vim.cmd.startinsert()
		end, vim.g.vscode and 200 or 0)
	end,
})
