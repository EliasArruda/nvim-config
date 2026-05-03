return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify", -- integração explícita
	},
	opts = {
		lsp = {
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true,
			},
			hover = {
				opts = { border = { style = "rounded" } },
			},
			signature = {
				enabled = true,
				opts = { border = { style = "rounded" } },
			},
		},
		cmdline = {
			format = {
				cmdline = { pattern = "^:", icon = "", lang = "vim" },
				search_down = { pattern = "^/", icon = "" },
				search_up = { pattern = "^%?", icon = "" },
				filter = { pattern = "^:%s*!", icon = "" },
				lua = { pattern = "^:%s*lua", icon = "" },
				help = { pattern = "^:%s*he?l?p?%s", icon = "" },
			},
		},
		routes = {
			-- ✅ notificações gerais vão pro nvim-notify
			{
				filter = { event = "notify" },
				view = "notify",
			},
			-- 📝 mensagens curtas vão pro mini
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
			-- 🔇 esconde buscas e mensagens de busca
			{
				filter = { event = "msg_show", find = "^/" },
				opts = { skip = true },
			},
			-- 🔇 esconde mensagens de busca do LSP
			{
				filter = { event = "msg_show", find = "^%?" },
				opts = { skip = true },
			},
		},
		presets = {
			bottom_search = true,
			command_palette = false,
			long_message_to_split = true,
			inc_rename = true,
			lsp_doc_border = true,
		},
		views = {
			-- 🖥️ popup do cmdline centralizado
			cmdline_popup = {
				position = { row = "40%", col = "50%" },
				size = { width = 60, height = "auto" },
				border = { style = "rounded", text = { top = "" } },
				win_options = {
					winblend = 10,
					winhighlight = "Normal:NoiceTransparent,FloatBorder:NoiceBorder",
				},
			},
			-- 📋 popupmenu de completions do cmdline
			popupmenu = {
				relative = "editor",
				position = { row = "43%", col = "50%" },
				size = { width = 60, height = 10 },
				border = { style = "rounded", text = { top = "" } },
				win_options = {
					winblend = 10,
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

		-- 🎨 Highlights transparentes do noice
		vim.api.nvim_set_hl(0, "NoiceTransparent", { bg = "NONE", fg = "NONE" })
		vim.api.nvim_set_hl(0, "NoiceBorder", { bg = "NONE", fg = "#565f89" })
		vim.api.nvim_set_hl(0, "NoiceCmdlinePopupTitle", { bg = "NONE", fg = "NONE" })
		vim.api.nvim_set_hl(0, "NoiceCmdlineIcon", { bg = "NONE", fg = "NONE" })
	end,
}
