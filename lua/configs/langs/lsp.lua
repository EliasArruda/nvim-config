return {
	roslyn = {},
	sqls = {},
	vue_ls = {},
	vtsls = {
		filetypes = {
			"javascript",
			"javascriptreact",
			"javascript.jsx",
			"typescript",
			"typescriptreact",
			"typescript.tsx",
			"vue",
		},
		settings = {
			vtsls = {
				tsserver = {
					globalPlugins = {
						{
							name = "@vue/typescript-plugin",
							location = vim.fn.stdpath("data")
								.. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
							languages = { "vue" },
							configNamespace = "typescript",
							enableForWorkspaceTypeScriptVersions = true,
						},
					},
				},
			},
		},
	},

	elixirls = {
		settings = {
			elixirLS = {
				dialyzerEnabled = true,
				fetchDeps = false, -- true se quiser que ele rode mix deps.get automaticamente
			},
		},
	},
	eslint = {},
	dockerls = {},
	jsonls = {},
	html = {},
	cssls = {},
	yamlls = { settings = { yaml = { validate = true } } },
	ruff = {
		on_attach = function(client, _)
			client.server_capabilities.hoverProvider = false
		end,
	},
	tailwindcss = {
		filetypes = {
			"html",
			"css",
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
			"vue",
			"svelte",
		},
		init_options = {
			userLanguages = { vue = "html" },
		},
		settings = {
			tailwindCSS = {
				validate = true,
				includeLanguages = {
					vue = "html",
					javascript = "html",
					typescript = "html",
				},
				classAttributes = { "class", "className", "class:list", "classList", "ngClass" },
				-- SEM experimental.classRegex
				lint = {
					cssConflict = "warning",
					invalidApply = "error",
					invalidConfigPath = "error",
					invalidScreen = "error",
					invalidTailwindDirective = "error",
					invalidVariant = "error",
					recommendedVariantOrder = "warning",
				},
			},
		},
	},
	pyright = {
		settings = {
			python = {
				analysis = {
					typeCheckingMode = "basic",
					autoSearchPaths = true,
					useLibraryCodeForTypes = true,
				},
			},
		},
	},
}
