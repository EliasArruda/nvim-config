if vim.g.neovide then
	return {
		{ "3rd/image.nvim", lazy = true, cond = false },
	}
else
	return {
		{ "sphamba/smear-cursor.nvim", lazy = true, cond = false },
	}
end
