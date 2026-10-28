local executor = {
	execute_command = function(command, args, cwd, opts)
		Snacks.terminal.open(vim.list_extend({ command }, args), {
			cwd = cwd,
			env = opts and opts.env,
			auto_close = false,
			win = { position = "bottom", height = 0.35 },
		})
	end,
}

return {
	{
		"mrcjkb/rustaceanvim",
		version = "^9",
		lazy = false,
		init = function()
			vim.g.rustaceanvim = {
				tools = { executor = executor, test_executor = executor, crate_test_executor = executor },
				dap = {
					autoload_configurations = false,
					configuration = {
						name = "Rust build and debug",
						type = "codelldb",
						request = "launch",
						sourceLanguages = { "rust" },
						preRunCommands = { "breakpoint set --func-regex '::main$' --one-shot true" },
					},
				},
				server = {
					cmd = function()
						return function(dispatchers, config)
							return vim.lsp.rpc.start(
								{ vim.fn.stdpath("config") .. "/bin/rust-analyzer" },
								dispatchers,
								{ cwd = config.root_dir }
							)
						end
					end,
					capabilities = require("blink.cmp").get_lsp_capabilities(),
					default_settings = {
						["rust-analyzer"] = {
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
