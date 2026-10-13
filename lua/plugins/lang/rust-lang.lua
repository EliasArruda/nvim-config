return {
	{
		"mrcjkb/rustaceanvim",
		version = "^9",
		lazy = false,
		init = function()
			vim.g.rustaceanvim = {
				server = {
					cmd = { vim.fn.stdpath("config") .. "/bin/rust-analyzer" },
					capabilities = function()
						return require("blink.cmp").get_lsp_capabilities()
					end,
					default_settings = {
						["rust-analyzer"] = {
							cargo = {
								allFeatures = true,
							},
							check = {
								command = "clippy",
								extraArgs = { "--no-deps" },
							},
							checkOnSave = true,
							procMacro = { enable = true },
							inlayHints = {
								chainingHints = { enable = true },
								typeHints = { enable = true },
								parameterHints = { enable = true },
							},
						},
					},
				},
			}
		end,
		dependencies = { "saghen/blink.cmp", "mfussenegger/nvim-dap" },
	},
}
