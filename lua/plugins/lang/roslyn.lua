return {
	{
		"seblyng/roslyn.nvim",
		--[[ commit "82d0c9724c3f8eab7342a3a136782b4788070bd0", ]]
		lazy = false,
		---@module 'roslyn.config'
		---@type RoslynNvimConfig
		ft = { "cs", "razor" },
		opts = {
			config = {
				settings = {
					["csharp|background_analysis"] = {
						dotnet_analyzer_diagnostics_scope = "openFiles",
						dotnet_compiler_diagnostics_scope = "openFiles",
					},
				},
			},
		},
	},
}
