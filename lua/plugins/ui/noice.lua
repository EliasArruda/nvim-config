return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify", -- integração explícita
	},
	opts = {
		throttle = 1000 / 60,
		lsp = {
			progress = {
				enabled = true,
				format = "lsp_progress",
				format_done = "lsp_progress_done",
				throttle = 1000 / 30, -- LSP progress em 30fps
				view = "mini",
			},
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true,
			},
			hover = {
				enabled = true,
				silent = false,
				opts = { border = { style = "rounded" } },
			},
			signature = {
				enabled = true,
				auto_open = {
					enabled = true,
					trigger = true,
					throttle = 50,
				},
				opts = { border = { style = "rounded" } },
			},
			message = {
				enabled = true,
				view = "notify",
			},
			documentation = {
				view = "hover",
				opts = {
					lang = "markdown",
					replace = true,
					render = "plain",
					format = { "{message}" },
					win_options = {
						concealcursor = "n",
						conceallevel = 3,
					},
				},
			},
		},
		cmdline = {
			enabled = true,
			view = "cmdline_popup",
			opts = {},
			format = {
				cmdline = { pattern = "^:", icon = " ", title = "CmdLine", lang = "vim" },
				search_down = { kind = "search", pattern = "^/", icon = "  ", lang = "regex" },
				search_up = { kind = "search", pattern = "^%?", icon = "  ", lang = "regex" },
				filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
				lua = {
					pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" },
					icon = "",
					lang = "lua",
				},
				help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
				input = { view = "cmdline_input", icon = "󰥻" },
			},
		},
		routes = {
			{
				filter = { event = "notify" },
				view = "notify",
			},
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
			{
				filter = { event = "msg_show", find = "^/" },
				opts = { skip = true },
			},
			{
				filter = { event = "msg_show", find = "^%?" },
				opts = { skip = true },
			},
		},
		presets = {
			bottom_search = true, -- cmdline clássica para busca (mais fluido)
			command_palette = true, -- cmdline + popupmenu juntos (recomendado)
			long_message_to_split = true, -- mensagens longas vão pra split
			inc_rename = true, -- input dialog para inc-rename.nvim
			lsp_doc_border = true, -- borda nas docs do LSP
		},
		views = {
			cmdline_popup = {
				position = { row = "45%", col = "50%" },
				size = { width = 60, height = "auto" },
				border = { style = "rounded", text = { top = "CmdLine" } },
				win_options = {
					winblend = 0,
					winhighlight = "Normal:NoiceTransparent,FloatBorder:NoiceBorder",
				},
			},
			-- 📋 popupmenu de completions do cmdline
			popupmenu = {
				relative = "editor",
				position = { row = "43%", col = "50%" },
				size = { width = 60, height = 10 },
				border = {
					style = "rounded",
					text = { top = " " },
				},
				win_options = {
					winblend = 0,
					winhighlight = "Normal:NoiceTransparent,FloatBorder:NoiceBorder",
				},
			},
			-- 💬 mini notifications (canto inferior direito)
			mini = {
				position = { row = -2, col = "100%" },
				border = { style = "rounded" },
				win_options = {
					winblend = 20,
					winhighlight = "Normal:NoiceTransparent,FloatBorder:NoiceBorder",
				},
			},
			-- 📖 hover docs
			hover = {
				border = { style = "rounded" },
				size = { max_width = 80 },
				win_options = {
					winblend = 10,
					winhighlight = "Normal:NoiceTransparent,FloatBorder:NoiceBorder",
				},
			},
			-- 🔔 notify usa o rcarriga/nvim-notify
			notify = {
				backend = "notify",
				fallback = "mini",
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

		vim.api.nvim_set_hl(0, "NoiceTransparent", { bg = "NONE", fg = "NONE" })
		vim.api.nvim_set_hl(0, "NoiceBorder", { bg = "NONE", fg = "#565f89" })
		vim.api.nvim_set_hl(0, "NoiceCmdlinePopupTitle", { bg = "NONE", fg = "NONE" })
		vim.api.nvim_set_hl(0, "NoiceCmdlineIcon", { bg = "NONE", fg = "NONE" })
		vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE" })
	end,
}
