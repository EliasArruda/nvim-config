return {
	{
		"ray-x/go.nvim",
		dependencies = {
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		ft = { "go", "gomod" },
		build = '<cmd>lua require("go.install").update_all()<cr>',
		config = function()
			require("go").setup({
				lsp_cfg = false,
				lsp_keymaps = false,
				lsp_codelens = false,
				lsp_inlay_hints = { enable = false },
				gofmt = "gofumpt",
				goimport = "",
				test_runner = "go",
				verbose = false,
				notify = false,
			})

			local run_and_quickfix = require("configs.langs.go-tools").run

			vim.api.nvim_create_user_command("GoLint", function()
				run_and_quickfix({
					"golangci-lint",
					"run",
					"--fast-only",
					"--output.text.path=",
					"--output.sarif.path=stdout",
					"--show-stats=false",
					"--path-mode=abs",
					"./...",
				}, "golangci-lint")
			end, {})

			vim.api.nvim_create_user_command("GoVulncheck", function()
				run_and_quickfix({ "govulncheck", "-format=sarif", "./..." }, "govulncheck")
			end, {})
		end,
		keys = {
			{ "<leader>ma", "<cmd>GoAddTag<CR>", desc = "Add struct tags" },
			{ "<leader>mr", "<cmd>GoRemoveTag<CR>", desc = "Remove struct tags" },
			{ "<leader>mi", "<cmd>GoImpl<CR>", desc = "Implement interface" },
			{ "<leader>mt", "<cmd>GoTestFunc<CR>", desc = "Run test at cursor" },
			{ "<leader>mT", "<cmd>GoTest<CR>", desc = "Run package tests" },
			{ "<leader>ml", "<cmd>GoLint<CR>", desc = "golangci-lint" },
			{ "<leader>mv", "<cmd>GoVulncheck<CR>", desc = "govulncheck" },
		},
	},
}
