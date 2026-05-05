return {
	"rachartier/tiny-inline-diagnostic.nvim",
	event = "LspAttach",
	priority = 1000,
	config = function()
		require("tiny-inline-diagnostic").setup({
			preset = "ghost",

			options = {
				show_all_diags_on_cursorline = true,
				enable_on_insert = false,
				overflow = {
					mode = "wrap",
				},
				multilines = {
					enabled = true,
					always_show = true,
				},
			},
		})

		vim.diagnostic.config({
			virtual_text = false,
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
		})
	end,
}
