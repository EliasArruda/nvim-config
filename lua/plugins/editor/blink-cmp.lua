return {
	{
		"saghen/blink.cmp",
		dependencies = "rafamadriz/friendly-snippets",
		version = "*",
		opts = {
			enabled = function()
				if vim.bo.buftype ~= "" then return false end
				if vim.bo.filetype == "netrw" then return false end
				if vim.bo.filetype == "TelescopePrompt" then return false end
				return true
			end,
			appearance = {
				nerd_font_variant = "mono",
				kind_icons = {
					Text = "", Method = "", Function = "", Constructor = "",
					Field = "", Variable = "", Class = "", Interface = "",
					Module = "", Property = "", Unit = "", Value = "",
					Enum = "", Keyword = "", Snippet = "", Color = "",
					File = "", Reference = "", Folder = "", EnumMember = "",
					Constant = "", Struct = "", Event = "", Operator = "",
					TypeParameter = "",
				},
			},
			keymap = {
				preset = "none",
				["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-e>"] = { "hide", "fallback" },
				["<CR>"] = { "accept", "fallback" },
				["<S-Tab>"] = { "snippet_backward", "fallback" },
				["<Up>"] = { "select_prev", "fallback" },
				["<Down>"] = { "select_next", "fallback" },
				["<C-p>"] = { "select_prev", "fallback" },
				["<C-n>"] = { "select_next", "fallback" },
				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },
			},
			completion = {
				keyword = { range = "full" },
				ghost_text = { enabled = true },
				list = { selection = { preselect = true, auto_insert = true } },
				menu = { border = "rounded", scrollbar = false, draw = { columns = { { "kind_icon", "label", gap = 1 }, { "kind" } } } },
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
					window = { border = "rounded", scrollbar = false, min_width = 55, max_width = 55, max_height = 12 },
				},
				accept = { auto_brackets = { enabled = true } },
			},
			signature = { enabled = false },
			sources = { default = { "lsp", "path", "snippets", "buffer" } },
		},
	},
}
