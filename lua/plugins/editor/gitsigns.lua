return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		signs = {
			add = { text = "│" },
			change = { text = "│" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
			untracked = { text = "┆" },
		},
		signcolumn = true,
		numhl = false,
		linehl = false,
		word_diff = false,
		watch_gitdir = {
			follow_files = true,
		},
		auto_attach = true,
		attach_to_untracked = false,
		current_line_blame = false,
		max_file_length = 40000,
		preview_config = {
			border = "rounded",
		},
	},
	keys = {
		{
			"<leader>ghb",
			function()
				require("gitsigns").blame_line({ full = true })
			end,
			desc = "Blame Line",
		},
		{
			"<leader>ghd",
			function()
				require("gitsigns").diffthis()
			end,
			desc = "Diff This",
		},
		{
			"<leader>ghD",
			function()
				require("gitsigns").diffthis("~")
			end,
			desc = "Diff This (against index)",
		},
		{
			"<leader>ghR",
			function()
				require("gitsigns").reset_buffer()
			end,
			desc = "Reset Buffer",
		},
		{
			"<leader>gho",
			function()
				require("gitsigns").toggle_current_line_blame()
			end,
			desc = "Toggle Blame",
		},
		{
			"<leader>ghS",
			function()
				require("gitsigns").stage_buffer()
			end,
			desc = "Stage Buffer",
		},
		{
			"<leader>ghp",
			function()
				require("gitsigns").preview_hunk()
			end,
			desc = "Preview Hunk",
		},
		{
			"]h",
			function()
				require("gitsigns").next_hunk()
			end,
			desc = "Next Hunk",
		},
		{
			"[h",
			function()
				require("gitsigns").prev_hunk()
			end,
			desc = "Prev Hunk",
		},
	},
}
