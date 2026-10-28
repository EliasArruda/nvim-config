vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost", "BufEnter" }, {
	group = vim.api.nvim_create_augroup("RustFileTemplates", { clear = true }),
	pattern = "*.rs",
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
			local main = name == "main.rs"
			local lines = main and { "fn main() {", '    println!("Hello, world!");', "}" }
				or { name == "lib.rs" and "//! Library documentation." or "//! Module documentation.", "", "" }
			vim.api.nvim_buf_set_lines(event.buf, 0, -1, false, lines)
			vim.api.nvim_win_set_cursor(0, { main and 2 or 3, main and 4 or 0 })
			vim.cmd.startinsert()
		end, vim.g.vscode and 200 or 0)
	end,
})
