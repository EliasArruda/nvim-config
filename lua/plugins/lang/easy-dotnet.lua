return {
	{
		"GustavEikaas/easy-dotnet.nvim",
		ft = { "cs", "razor" },
		event = {
			"BufReadPre *.csproj",
			"BufReadPre *.sln",
			"BufReadPre *.slnx",
			"BufReadPre *.props",
			"BufReadPre *.targets",
		},
		cmd = { "Dotnet" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"folke/snacks.nvim",
			"mfussenegger/nvim-dap",
			"saghen/blink.cmp",
		},
		keys = {
			{ "<leader>nn", "<cmd>Dotnet new<cr>", desc = ".NET Create project/solution" },
			{ "<leader>nf", "<cmd>Dotnet createfile<cr>", desc = ".NET Create file" },
			{ "<leader>ns", "<cmd>Dotnet solution select<cr>", desc = ".NET Select solution" },
			{ "<leader>na", "<cmd>Dotnet solution add<cr>", desc = ".NET Add project to solution" },
			{ "<leader>nR", "<cmd>Dotnet restore<cr>", desc = ".NET Restore packages" },
			{ "<leader>nl", "<cmd>Dotnet lsp restart<cr>", desc = ".NET Restart Roslyn" },
			{ "<leader>nr", "<cmd>Dotnet run default<cr>", desc = ".NET Run default project" },
			{ "<leader>nw", "<cmd>Dotnet watch default<cr>", desc = ".NET Watch default project" },
			{ "<leader>nd", "<cmd>Dotnet debug default<cr>", desc = ".NET Debug default project" },
			{ "<leader>nt", "<cmd>Dotnet testrunner<cr>", desc = ".NET Test runner" },
			{ "<leader>nb", "<cmd>Dotnet build default quickfix<cr>", desc = ".NET Build default project" },
		},
		opts = {
			picker = "snacks",
			enable_filetypes = false, -- Core registers .NET JSON as jsonc, with parser/formatter support.
			-- easy-dotnet owns the complete Roslyn + Razor co-hosting pipeline,
			-- including virtual C#/HTML documents and their lifecycle.
			lsp = {
				enabled = true,
				preload_roslyn = true,
				roslynator_enabled = true,
				easy_dotnet_analyzer_enabled = true,
				restart_roslyn_on_branch_change = true,
				auto_refresh_codelens = false,
				razor = {
					enabled = true,
					html = {
						enabled = true,
						request_timeout = 5000,
					},
				},
				config = {
					capabilities = vim.tbl_deep_extend("force", require("blink.cmp").get_lsp_capabilities(), {
						workspace = {
							didChangeWatchedFiles = { dynamicRegistration = vim.uv.os_uname().sysname ~= "Linux" },
						},
					}),
					settings = {
						["csharp|background_analysis"] = {
							dotnet_analyzer_diagnostics_scope = "openFiles",
							dotnet_compiler_diagnostics_scope = "fullSolution",
						},
						["csharp|completion"] = {
							dotnet_provide_regex_completions = true,
							dotnet_show_completion_items_from_unimported_namespaces = true,
							dotnet_show_name_completion_suggestions = true,
						},
						["csharp|code_lens"] = {
							dotnet_enable_references_code_lens = true,
							dotnet_enable_tests_code_lens = true,
						},
						["csharp|inlay_hints"] = {
							csharp_enable_inlay_hints_for_implicit_object_creation = true,
							csharp_enable_inlay_hints_for_implicit_variable_types = true,
							csharp_enable_inlay_hints_for_lambda_parameter_types = true,
							csharp_enable_inlay_hints_for_types = true,
							dotnet_enable_inlay_hints_for_indexer_parameters = true,
							dotnet_enable_inlay_hints_for_literal_parameters = true,
							dotnet_enable_inlay_hints_for_object_creation_parameters = true,
							dotnet_enable_inlay_hints_for_other_parameters = true,
							dotnet_enable_inlay_hints_for_parameters = true,
							dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
							dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
							dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
						},
						["csharp|symbol_search"] = {
							dotnet_search_reference_assemblies = true,
						},
						["csharp|formatting"] = {
							dotnet_organize_imports_on_format = true,
						},
					},
				},
			},
			debugger = {
				auto_register_dap = true,
				engine = "netcoredbg",
				console = "integratedTerminal",
			},
			test_runner = {
				auto_start_testrunner = true,
				viewmode = "float",
				neotest_integration = false,
			},
			auto_bootstrap_namespace = { enabled = false },
			diagnostics = {
				default_severity = "warning",
				setqflist = false,
			},
		},
		config = function(_, opts)
			require("easy-dotnet").setup(opts)
			local dap = require("dap")
			-- easy-dotnet registers its launcher for cs only.
			dap.configurations.razor = dap.configurations.cs
			vim.api.nvim_create_autocmd("BufWritePost", {
				group = vim.api.nvim_create_augroup("dotnet_new_files", { clear = true }),
				pattern = { "*.cs", "*.razor", "*.cshtml", "*.csproj" },
				callback = function(event)
					local name = event.match:match("%.csproj$") and "easy_dotnet_projx" or "easy_dotnet"
					-- Retry root detection after the file exists, outside the write event.
					vim.schedule(function()
						if
							vim.api.nvim_buf_is_valid(event.buf)
							and #vim.lsp.get_clients({ bufnr = event.buf, name = name }) == 0
						then
							vim.api.nvim_exec_autocmds("FileType", { group = "nvim.lsp.enable", buffer = event.buf })
						end
					end)
				end,
			})
		end,
	},
}
