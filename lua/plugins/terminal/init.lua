return {

	{
		"3rd/image.nvim",
		cond = not vim.g.neovide,
		config = function()
			local ok, _ = pcall(require, "image")
			if not ok then
				vim.notify("image.nvim não carregado - hererocks pode estar faltando", vim.log.levels.WARN)
				return
			end

			-- Detecta o backend automaticamente
			local backend = "ueberzug"
			if vim.env.KITTY_WINDOW_ID then
				backend = "kitty"
			elseif vim.env.WEZTERM_PANE then
				backend = "kitty" -- WezTerm suporta protocolo kitty
			elseif vim.env.SSH_TTY or vim.env.SSH_CONNECTION then
				backend = "sixel"
			end

			require("image").setup({
				backend = backend,
				max_height_window_percentage = 50,
				hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.svg" },
			})
		end,
	},
}
