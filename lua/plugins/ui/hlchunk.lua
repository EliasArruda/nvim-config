return {
	"shellRaining/hlchunk.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("hlchunk").setup({
			chunk = {
				enable = true,
				delay = 50,
				duration = 100,
				style = {
					{ fg = "#806d9c" },
				},
				exclude_filetypes = {
					aerial = true,
					dashboard = true,
					help = true,
					lazy = true,
				},
			},
			indent = {
				enable = true,
				delay = 50,
				style = {
					{ fg = "#3b3b3b" },
				},
			},
			line_num = {
				enable = true,
				delay = 50,
				style = {
					{ fg = "#806d9c" },
				},
			},
			blank = {
				enable = false,
			},
		})
	end,
}
