return {
	"mistweaverco/kulala.nvim",
	ft = { "http" },

	keys = {
		{
			"<C-p>",
			function()
				require("kulala").run()
			end,
			desc = "Run HTTP request",
			mode = "n", -- normal mode
		},
	},
}
