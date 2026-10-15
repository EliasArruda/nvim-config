return {
	{
		"tpope/vim-rails",
		ft = { "ruby", "eruby" },
		dependencies = {
			"tpope/vim-projectionist",
			"tpope/vim-bundler",
		},
	},
	{
		"nvim-neotest/neotest",
		ft = { "ruby", "eruby" },
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"olimorris/neotest-rspec",
			"zidhuss/neotest-minitest",
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-rspec")({}),
					require("neotest-minitest")({}),
				},
				output = { open_on_run = true },
				quickfix = { open = false },
				status = { virtual_text = true, signs = true },
			})
		end,
		keys = {
			{ "<leader>rt", function() require("neotest").run.run() end, desc = "Ruby: test nearest" },
			{ "<leader>rf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Ruby: test file" },
			{ "<leader>rs", function() require("neotest").summary.toggle() end, desc = "Ruby: test summary" },
			{ "<leader>ro", function() require("neotest").output.open({ enter = true }) end, desc = "Ruby: test output" },
			{ "<leader>rl", function() require("neotest").run.run_last() end, desc = "Ruby: test last" },
			{ "[t", function() require("neotest").jump.prev({ status = "failed" }) end, desc = "Previous failed test" },
			{ "]t", function() require("neotest").jump.next({ status = "failed" }) end, desc = "Next failed test" },
		},
	},
}
