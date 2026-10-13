return {
	"rebelot/kanagawa.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		theme = "dragon",
		background = { dark = "dragon", light = "lotus" },
		transparent = false,
		commentStyle = { italic = false },
		keywordStyle = { italic = false },
		terminalColors = true,
	},
	config = function(_, opts)
		vim.o.background = "dark"
		require("kanagawa").setup(opts)
		vim.cmd.colorscheme(require("config.settings").colorscheme)
	end,
}
