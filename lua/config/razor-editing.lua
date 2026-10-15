local M = {}

function M.between_tags()
	local _, col = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_get_current_line()
	local before, after = line:sub(1, col), line:sub(col + 1)
	local name = before:match("<([%a_][%w_.:-]*)[^<>]*>$")
	local closing = after:match("^</([%a_][%w_.:-]*)%s*>")
	if vim.bo.filetype ~= "razor" or name == nil or name ~= closing or before:match("/>$") then
		return false
	end
	-- Enter can run before the next redraw/parser update, especially just after
	-- accepting a snippet. Refresh the incremental tree before checking C#.
	local parsed = pcall(function()
		vim.treesitter.get_parser(0, "razor"):parse(true)
	end)
	return parsed and not require("configs.langs.razor").is_code_or_comment()
end

function M.split()
	if not M.between_tags() then
		return
	end
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_get_current_line()
	local base = line:match("^%s*") or ""
	local indent = base .. (vim.bo.expandtab and string.rep(" ", vim.fn.shiftwidth()) or "\t")
	vim.api.nvim_buf_set_lines(0, row - 1, row, false, { line:sub(1, col), indent, base .. line:sub(col + 1) })
	vim.api.nvim_win_set_cursor(0, { row + 1, #indent })
end

return M
