return {
	"stevearc/conform.nvim",
	dependencies = { "williamboman/mason.nvim" },
	cmd = { "ConformInfo" }, -- Carregado via keys; autocmd no config gerencia BufWritePre
	keys = {
		{
			"<leader>cF",
			function()
				require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
			end,
			mode = { "n", "x" },
			desc = "Format Injected Langs",
		},
		{
			"<leader>cf",
			function()
				require("conform").format({ timeout_ms = 3000 })
			end,
			mode = { "n", "x" },
			desc = "Format Buffer",
		},
	},
	config = function()
		local opts = require("configs.langs.conform")
		require("conform").setup(opts)
	end,
}
