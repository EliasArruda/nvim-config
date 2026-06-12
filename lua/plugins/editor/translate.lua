return {
	"uga-rosa/translate.nvim",
	cmd = "Translate",
	keys = {
		{ "<leader>tr", "viw:Translate EN -output=replace<CR>", desc = "Translate word", mode = "n" },
		{ "<leader>tr", ":Translate EN -output=replace<CR>", desc = "Translate selection", mode = "x" },
	},
	opts = {
		default = {
			command = "google",
		},
	},
}
