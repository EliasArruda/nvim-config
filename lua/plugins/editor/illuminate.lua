return {
	"RRethy/vim-illuminate",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("illuminate").configure({
			providers = {
				"lsp",
				"treesitter",
				"regex",
			},
			delay = 200,
			filetypes_denylist = {
				"TelescopePrompt",
				"neo-tree",
				"neo-tree-popup",
				"notify",
				"alpha",
				"NvimTree",
			},
		})
	end,
}
