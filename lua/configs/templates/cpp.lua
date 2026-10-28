vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost", "BufEnter" }, {
	group = vim.api.nvim_create_augroup("CppFileTemplates", { clear = true }),
	pattern = { "*.c", "*.cpp", "*.cc", "*.cxx", "*.C", "*.h", "*.hpp", "*.hh", "*.hxx", "*.H" },
	callback = function(event)
		local common = require("configs.templates.common")
		if not common.eligible(event) then
			return
		end
		vim.defer_fn(function()
			if vim.api.nvim_get_current_buf() ~= event.buf or not common.eligible(event) then
				return
			end
			local path = vim.api.nvim_buf_get_name(event.buf)
			local extension = vim.fn.fnamemodify(path, ":e")
			local stem = vim.fn.fnamemodify(path, ":t:r")
			local lines, line, column
			if vim.tbl_contains({ "h", "hpp", "hh", "hxx", "H" }, extension) then
				lines, line, column = { "#pragma once", "", "" }, 3, 0
			else
				local is_c = extension == "c"
				local include = is_c and "#include <stdio.h>" or "#include <iostream>"
				if stem == "main" then
					lines = { include, "", is_c and "int main(void) {" or "int main() {", "    ", "    return 0;", "}" }
					line, column = 4, 4
				else
					for _, suffix in ipairs(is_c and { ".h" } or { ".hpp", ".hh", ".hxx", ".h", ".H" }) do
						local header = vim.fs.dirname(path) .. "/" .. stem .. suffix
						local stat = vim.uv.fs_stat(header)
						if stat and stat.type == "file" then
							include = '#include "' .. stem .. suffix .. '"'
							break
						end
					end
					lines, line, column = { include, "", "" }, 3, 0
				end
			end
			vim.api.nvim_buf_set_lines(event.buf, 0, -1, false, lines)
			vim.api.nvim_win_set_cursor(0, { line, column })
			vim.cmd.startinsert()
		end, vim.g.vscode and 200 or 0)
	end,
})
