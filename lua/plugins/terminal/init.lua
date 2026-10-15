return {

	{
		"3rd/image.nvim",
		cond = function()
			return not vim.g.neovide and #vim.api.nvim_list_uis() > 0
		end,
		config = function()
			local ok, _ = pcall(require, "image")
			if not ok then
				vim.notify("image.nvim could not be loaded; inspect :messages", vim.log.levels.WARN)
				return
			end

			-- Detecta o backend automaticamente
			local backend = vim.env.NVIM_IMAGE_BACKEND or "ueberzug"
			if vim.env.NVIM_IMAGE_BACKEND then
				backend = vim.env.NVIM_IMAGE_BACKEND
			elseif vim.env.KITTY_WINDOW_ID then
				backend = "kitty"
			elseif vim.env.WEZTERM_PANE then
				backend = "kitty" -- WezTerm suporta protocolo kitty
			elseif vim.env.SSH_TTY or vim.env.SSH_CONNECTION then
				return -- Set NVIM_IMAGE_BACKEND explicitly for a remote terminal.
			end

			require("image").setup({
				backend = backend,
				max_height_window_percentage = 50,
				hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.svg" },
			})
		end,
	},
}
