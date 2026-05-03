return {
	{
		"seblyng/roslyn.nvim",
		lazy = false,
		---@module 'roslyn.config'
		---@type RoslynNvimConfig
		ft = { "cs", "razor" },
		init = function()
			-- só seta se ainda não foi selecionado
			if not vim.g.roslyn_nvim_selected_solution then
				local sln_files = vim.fs.find(function(name)
					return name:match("%.sln$")
				end, { path = vim.uv.cwd(), type = "file", limit = math.huge })

				if #sln_files == 1 then
					-- só um .sln? seleciona automaticamente
					vim.g.roslyn_nvim_selected_solution = sln_files[1]
				end
				-- se tiver mais de um, deixa o :Roslyn target decidir
			end
		end,
		opts = {
			lock_target = true,
			filewatching = "off",
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
