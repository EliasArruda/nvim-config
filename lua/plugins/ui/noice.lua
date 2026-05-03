return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {
		lsp = {
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true,
			},
			-- 💬 Hover e signature com borda arredondada
			hover = {
				opts = { border = { style = "rounded" } },
			},
			signature = {
				enabled = true,
				opts = { border = { style = "rounded" } },
			},
		},

		routes = {
			-- Mensagens curtas vão pro mini (canto inferior direito)
			{
				filter = {
					event = "msg_show",
					any = {
						{ find = "%d+L, %d+B" },
						{ find = "; after #%d+" },
						{ find = "; before #%d+" },
						{ find = "written" },
						{ find = "yanked" },
					},
				},
				view = "mini",
			},
			-- Esconde mensagens de busca desnecessárias
			{
				filter = { event = "msg_show", find = "^/" },
				opts = { skip = true },
			},
		},

		presets = {
			bottom_search = true,
			command_palette = true,
			long_message_to_split = true,
			inc_rename = true, -- renaming mais bonito
			lsp_doc_border = true, -- borda nos docs do LSP
		},

		-- 🎨 Customização das views
		views = {
			cmdline_popup = {
				position = { row = "40%", col = "50%" }, -- centralizado
				size = { width = 60, height = "auto" },
				border = { style = "rounded" },
				win_options = {
					winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
				},
			},
			popupmenu = {
				relative = "editor",
				position = { row = "43%", col = "50%" },
				size = { width = 60, height = 10 },
				border = { style = "rounded" },
				win_options = {
					winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
				},
			},
			mini = {
				position = { row = -2, col = "100%" }, -- canto inferior direito
				border = { style = "rounded" },
				win_options = {
					winblend = 10, -- leve transparência
				},
			},
			hover = {
				border = { style = "rounded" },
				size = { max_width = 80 },
			},
		},
	},

	keys = {
		{
			"<leader>sn",
			"",
			desc = "+noice",
		},
		{
			"<S-Enter>",
			function()
				require("noice").redirect(vim.fn.getcmdline())
			end,
			mode = "c",
			desc = "Redirect Cmdline",
		},
		{
			"<leader>snl",
			function()
				require("noice").cmd("last")
			end,
			desc = "Noice Last Message",
		},
		{
			"<leader>snh",
			function()
				require("noice").cmd("history")
			end,
			desc = "Noice History",
		},
		{
			"<leader>sna",
			function()
				require("noice").cmd("all")
			end,
			desc = "Noice All",
		},
		{
			"<leader>snd",
			function()
				require("noice").cmd("dismiss")
			end,
			desc = "Dismiss All",
		},
		{
			"<leader>snt",
			function()
				require("noice").cmd("pick")
			end,
			desc = "Noice Picker",
		},
		{
			"<C-f>",
			function()
				if not require("noice.lsp").scroll(4) then
					return "<C-f>"
				end
			end,
			silent = true,
			expr = true,
			desc = "Scroll Forward",
			mode = { "i", "n", "s" },
		},
		{
			"<C-b>",
			function()
				if not require("noice.lsp").scroll(-4) then
					return "<C-b>"
				end
			end,
			silent = true,
			expr = true,
			desc = "Scroll Backward",
			mode = { "i", "n", "s" },
		},
	},

	config = function(_, opts)
		if vim.o.filetype == "lazy" then
			vim.cmd([[messages clear]])
		end
		require("noice").setup(opts)
	end,
}
