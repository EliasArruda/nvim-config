return {
	{
		"folke/noice.nvim",
		optional = true,
		opts = function(_, opts)
			opts.views = opts.views or {}
			opts.views.hover = opts.views.hover or {}
			opts.views.hover.scrollbar = false
			opts.views.hover.size = {
				width = 60,
				max_height = 12,
			}
			opts.views.hover.border = { style = "rounded" }
			opts.views.hover.position = { row = 2, col = 2 }
		end,
	},
	-- Noice gerencia hover/signature. Removido handlers duplicados do lspconfig.
}

