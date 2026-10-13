return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		bigfile = { enabled = true, size = 1024 * 1024, line_length = 1000 },
		animate = { enabled = false },
		terminal = { enabled = true },
		explorer = {
			enabled = true,
			exclude = { "bin", "obj", ".git", "node_modules", "%.git" },
		},
		picker = {
			icons = { files = { dir = "", dir_open = "", file = "" } },
			enabled = true,
			exclude = { "bin", "obj", ".git", "node_modules", "%.git" },
		},
		notifier = { enabled = false }, -- Noice/nvim-notify já gerenciam notificações
		indent = { enabled = true },
		input = { enabled = false },
		scope = { enabled = false },
		scroll = { enabled = false },
		words = { enabled = false },
		styles = {
			terminal = {
				position = "bottom",
				height = 0.35,
				wo = {
					winfixheight = true,
					winfixwidth = true,
				},
			},
			explorer = {
				position = "left",
				width = 22,
				wo = {
					winfixwidth = true,
				},
			},
		},
		dashboard = {
			enabled = true,
			preset = {
				header = "NEOVIM  /  WORKSPACE\n\nCode. Navigate. Build.",
			},
			sections = {
				{ section = "header" },
			},
		},
	},
	config = function(_, opts)
		require("snacks").setup(opts)
		require("core.toggles").setup()
	end,
	keys = {
		{
			"<leader>e",
			function()
				Snacks.explorer({ cwd = require("core.project").root() })
			end,
			desc = "File Explorer",
		},
		{
			"<leader>fT",
			function()
				Snacks.terminal()
			end,
			desc = "Terminal Inferior",
		},
		{
			"<leader>un",
			function()
				vim.cmd("Noice history")
			end,
			desc = "Notificações",
		},
		{
			"<leader>uX",
			function()
				vim.cmd("Noice dismiss")
			end,
			desc = "Descartar Notificações",
		},
	},
}
