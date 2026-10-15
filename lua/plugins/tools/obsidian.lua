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
		{ "<leader>p", "<cmd>PastifyAfter<CR>", mode = "x", desc = "📋 Paste after" },
		{ "<leader>p", "<cmd>PastifyAfter<CR>", mode = "n", desc = "📋 Paste after" },
		{ "<leader>P", "<cmd>Pastify<CR>", mode = "n", desc = "📌 Paste before" },
	},
	config = function(_, opts)
		-- render-markdown.nvim owns the Markdown UI; Obsidian still provides
		-- workspaces, links, completion, daily notes, and commands.
		require("obsidian").setup(opts)

		-- setup do markdown-table-mode
		require("markdown-table-mode").setup({
			filetype = { "*.md" },
			options = {
				insert = true,
				insert_leave = true,
				pad_separator_line = false,
				align_style = "default",
			},
		})
		-- :Mtm alterna o estado global. Execute apenas uma vez ao carregar o
		-- plugin; ele mesmo gerencia BufEnter/BufLeave depois disso.
		vim.cmd("Mtm")
	end,
	opts = {
		legacy_commands = false,
		-- Não insira automaticamente id/aliases/tags nos arquivos Markdown.
		frontmatter = {
			enabled = false,
		},
		workspaces = vim.fn.isdirectory(vim.fn.expand("~/obsidian")) == 1 and {
			{
				name = "notes",
				path = "~/obsidian",
			},
		} or {},
		daily_notes = {
			folder = "dailies",
			date_format = "%Y-%m-%d",
		},
		ui = { enable = false },
	},
}
