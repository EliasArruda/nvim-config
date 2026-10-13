return {
	{ "dasupradyumna/midnight.nvim", lazy = true },
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		version = false,
		opts = { style = "night", transparent = false, terminal_colors = true,
			styles = { comments = { italic = false }, keywords = { italic = false }, sidebars = "dark", floats = "dark" },
			dim_inactive = false, lualine_bold = false },
		config = function(_, opts)
			require("tokyonight").setup(opts)
			vim.cmd.colorscheme(require("config.settings").colorscheme)
		end,
	},
}
