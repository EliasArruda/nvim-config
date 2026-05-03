return {
	"smjonas/inc-rename.nvim",
	opts = {},
	keys = {
		{
			"<leader>mr",
			function()
				return ":IncRename " .. vim.fn.expand("<cword>")
			end,
			expr = true,
			desc = "LSP Rename (snacks input)",
		},
	},
}
