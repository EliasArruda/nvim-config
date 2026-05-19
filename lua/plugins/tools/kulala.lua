return {
	"mistweaverco/kulala.nvim",
	ft = { "http" },

	keys = {
		{
			"<leader>rr",
			function()
				require("kulala").run()
			end,
			desc = "Run HTTP request",
		},
	},
}
