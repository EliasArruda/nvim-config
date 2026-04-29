vim.api.nvim_create_autocmd("InsertEnter", {
	callback = function()
		vim.g.neovide_opacity = 0.98
	end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
	callback = function()
		vim.g.neovide_opacity = 0.95
	end,
})
