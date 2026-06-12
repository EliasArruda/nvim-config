return {
	"smjonas/inc-rename.nvim",
	opts = {},
	keys = {
		{
			"<leader>cn",
			function()
				return ":IncRename " .. vim.fn.expand("<cword>")
			end,
			expr = true,
			desc = "LSP Rename (inc-rename)",
		},
	},
}
