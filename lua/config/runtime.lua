local M = {}
function M.is_large(buf)
	buf = buf or 0
	if vim.bo[buf].filetype == "bigfile" or vim.b[buf].completion == false then
		return true
	end
	local size = vim.uv.fs_stat(vim.api.nvim_buf_get_name(buf))
	return size and size.size > require("config.settings").large_file_bytes or false
end
function M.setup()
	vim.opt.winborder = "rounded"
	vim.opt.pumblend = 0
	vim.opt.completeopt = "menu,menuone,noselect"
	vim.opt.autowrite = false
	vim.opt.smoothscroll = false
	vim.opt.synmaxcol = 300
	vim.g.snacks_animate = false
	-- Keep layout and filesystem state within the project that owns the buffer.
	vim.api.nvim_create_autocmd("DirChanged", {
		group = vim.api.nvim_create_augroup("config_project_changed", { clear = true }),
		callback = function()
			vim.g.nvim_project_root = nil
		end,
	})
end
return M
