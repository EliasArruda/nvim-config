return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	version = false,
	opts = {
		style = "night",
		transparent = false,
		terminal_colors = true,
		styles = {
			comments = { italic = false },
			keywords = { italic = false },
			sidebars = "dark",
			floats = "dark",
		},
		dim_inactive = false,
		lualine_bold = false,
		-- Near-black neutral surfaces; keep TokyoNight's syntax palette.
		on_colors = function(colors)
			colors.bg = "#080c10"
			colors.bg_dark = "#06090d"
			colors.bg_dark1 = "#06090d"
			colors.bg_float = "#10151b"
			colors.bg_popup = "#10151b"
			colors.bg_sidebar = "#080c10"
			colors.bg_statusline = "#10151b"
			colors.bg_highlight = "#141c25"
			colors.bg_visual = "#223044"
			colors.border = "#25303c"
			colors.border_highlight = "#46566b"
			colors.fg_gutter = "#59687b"
			colors.comment = "#79889b"
			colors.terminal_black = "#10151b"
		end,
	},
	config = function(_, opts)
		vim.o.background = "dark"
		require("tokyonight").setup(opts)
		vim.cmd.colorscheme(require("config.settings").colorscheme)
	end,
}
