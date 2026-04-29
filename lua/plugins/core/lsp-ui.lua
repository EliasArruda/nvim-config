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
	{
		"neovim/nvim-lspconfig",
		opts = function()
			-- Hover (Shift + K)
			vim.lsp.handlers["textDocument/hover"] = function(err, result, ctx, config)
				config = vim.tbl_extend("force", config or {}, {
					border = "rounded",
					max_width = 60,
					max_height = 12,
					focusable = false,
				})
				vim.lsp.handlers.hover(err, result, ctx, config)
			end

			-- Signature Help
			vim.lsp.handlers["textDocument/signatureHelp"] = function(err, result, ctx, config)
				config = vim.tbl_extend("force", config or {}, {
					border = "rounded",
					max_width = 60,
					max_height = 12,
				})
				vim.lsp.handlers.signature_help(err, result, ctx, config)
			end
		end,
	},
}
