return {
	"obsidian-nvim/obsidian.nvim",
	version = "*",
	lazy = true,
	ft = "markdown",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"Kicamon/markdown-table-mode.nvim",
		"TobinPalmer/pastify.nvim",
	},

	cmd = { "Pastify", "PastifyAfter" },
	keys = {
		keys = {
			{ "<leader>p", "<cmd>PastifyAfter<CR>", mode = "x", desc = "📋 Paste after" },
			{ "<leader>p", "<cmd>PastifyAfter<CR>", mode = "n", desc = "📋 Paste after" },
			{ "<leader>P", "<cmd>Pastify<CR>", mode = "n", desc = "📌 Paste before" },
		},
	},

	config = function()
		-- setup do markdown-table-mode
		require("markdown-table-mode").setup({
			filetype = { "*.md" },
			options = {
				insert = true,
				insert_leave = true,
				pad_separator_line = false,
				alig_style = "default",
			},
		})

		-- 🔥 ativa automaticamente no markdown
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "markdown",
			callback = function()
				-- evita erro se já estiver ativo
				pcall(vim.cmd, "Mtm")
			end,
		})
	end,

	opts = {
		legacy_commands = false,

		workspaces = {
			{
				name = "notes",
				path = "~/obsidian",
			},
		},

		daily_notes = {
			folder = "dailies",
			date_format = "%Y-%m-%d",
		},

		completion = {
			nvim_cmp = false,
			min_chars = 2,
		},
	},
}
