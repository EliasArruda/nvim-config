	return {
	"stevearc/conform.nvim",
	dependencies = { "williamboman/mason.nvim" },
	event = { "BufReadPre", "BufNewFile" },
	cmd = { "ConformInfo" },
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
		opts.format_on_save = vim.g.autoformat and {
			timeout_ms = 3000,
		} or nil
		require("conform").setup(opts)
	end,
}
