return {
	{
		"ray-x/go.nvim",
		dependencies = {
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		ft = { "go", "gomod" },
		build = ':lua require("go.install").update_all_sync()',
		config = function()
			require("go").setup({
				lsp_cfg = false,
				lsp_keymaps = false,
			})
		end,
	},
}
