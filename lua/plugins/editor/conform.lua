return {
	"stevearc/conform.nvim",
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
		opts.format_on_save = function(bufnr)
			if require("config.runtime").is_large(bufnr) or vim.g.autoformat == false or vim.b[bufnr].autoformat == false then
				return
			end
			return { timeout_ms = vim.bo[bufnr].filetype == "razor" and 5000 or 3000 }
		end
		require("conform").setup(opts)
	end,
}
