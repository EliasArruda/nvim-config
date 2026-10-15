return {
	"mrjones2014/smart-splits.nvim",
	opts = {
		at_edge = "stop", -- Não sai do Neovim ao bater na borda
		ignored_filetypes = { "nofile", "quickfix", "qf", "prompt" },
	},
	keys = {
		-- Mover entre janelas (Modo Normal)
		{
			"<C-h>",
			function()
				require("smart-splits").move_cursor_left()
			end,
		},
		{
			"<C-j>",
			function()
				require("smart-splits").move_cursor_down()
			end,
		},
		{
			"<C-k>",
			function()
				require("smart-splits").move_cursor_up()
			end,
		},
		{
			"<C-l>",
			function()
				require("smart-splits").move_cursor_right()
			end,
		},

		-- Mover entre janelas (Modo Terminal - permite sair do terminal com um comando)
		{
			"<C-h>",
			function()
				require("smart-splits").move_cursor_left()
			end,
			mode = "t",
		},
		{
			"<C-j>",
			function()
				require("smart-splits").move_cursor_down()
			end,
			mode = "t",
		},
		{
			"<C-k>",
			function()
				require("smart-splits").move_cursor_up()
			end,
			mode = "t",
		},
		{
			"<C-l>",
			function()
				require("smart-splits").move_cursor_right()
			end,
			mode = "t",
		},

		-- Redimensionar com Alt + hl (j e k ficam livres para mover linhas)
		{
			"<A-h>",
			function()
				require("smart-splits").resize_left()
			end,
		},
		{
			"<A-l>",
			function()
				require("smart-splits").resize_right()
			end,
		},
	},
}
