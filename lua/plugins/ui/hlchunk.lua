return {
	enabled = false,
	"shellRaining/hlchunk.nvim",
	config = function()
		require("hlchunk").setup({
			chunk = {
				enable = false,
			},
			indent = {
				enable = true,
				chars = { "│" },
			},
		})
	end,
}
