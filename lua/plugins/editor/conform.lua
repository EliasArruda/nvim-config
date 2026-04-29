return {
	"stevearc/conform.nvim",
	dependencies = { "williamboman/mason.nvim" },
	event = { "BufWritePre" },
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
		require("conform").setup(opts)

		vim.api.nvim_create_autocmd("BufWritePre", {
			group = vim.api.nvim_create_augroup("conform_format_on_save", { clear = true }),
			callback = function()
				require("conform").format({
					bufnr = vim.api.nvim_get_current_buf(),
					timeout_ms = 3000,
				})
			end,
		})
	end,
}
