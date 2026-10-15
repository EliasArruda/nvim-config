local M = {}

function M.eligible(event)
	local buf = event.buf
	if not vim.api.nvim_buf_is_valid(buf) or not vim.bo[buf].modifiable then
		return false
	end
	local kind = vim.bo[buf].buftype
	if kind ~= "" and not (vim.g.vscode and kind == "acwrite" and vim.b[buf].vscode_controlled) then
		return false
	end
	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	if #lines ~= 1 or lines[1] ~= "" then
		return false
	end
	if event.event == "BufNewFile" then
		return true
	end
	-- Explorers create the empty file before opening it; leave older files alone.
	local stat = vim.uv.fs_stat(vim.api.nvim_buf_get_name(buf))
	local age = stat and (os.time() - stat.mtime.sec)
	return stat ~= nil and stat.type == "file" and stat.size == 0 and age >= 0 and age <= 10
end

return M
