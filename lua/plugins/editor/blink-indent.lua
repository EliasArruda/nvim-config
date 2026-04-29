return {
	"saghen/blink.indent",
	event = "BufReadPre",

	opts = {
		blocked = {
			buftypes = { include_defaults = true },
			filetypes = { include_defaults = true },
		},

		mappings = {
			border = "top",
			object_scope = "ii",
			object_scope_with_border = "ai",
			goto_top = "[i",
			goto_bottom = "]i",
		},

		static = {
			enabled = false,
		},

		scope = {
			enabled = true,
			char = "",
			priority = 1000,

			highlights = { "BlinkIndentScope" },
			underline = {
				enabled = true,
				highlights = { "BlinkIndentScopeUnderline" },
			},
		},
	},

	config = function(_, opts)
		require("blink.indent").setup(opts)
		vim.api.nvim_set_hl(0, "BlinkIndentScope", { fg = "#3aa6b9", bold = true })
		vim.api.nvim_set_hl(0, "BlinkIndentScopeUnderline", {
			undercurl = true,
			sp = "#3aa6b9",
			bold = true,
		})
	end,
}
