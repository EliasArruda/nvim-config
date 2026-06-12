local function get_vue_language_server_path()
	local ok, pkg = pcall(require, "mason-registry")
	if ok then
		ok, pkg = pcall(pkg.get_package, "vue-language-server")
		if ok and pkg:is_installed() then
			return pkg:get_install_path() .. "/node_modules/@vue/language-server"
		end
	end
	-- Fallback: path hardcoded caso o Mason não esteja disponível
	return vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
end

local vue_plugin = {
	name = "@vue/typescript-plugin",
	location = get_vue_language_server_path(),
	languages = { "vue" },
	configNamespace = "typescript",
}

return {
	sqls = {},
	roslyn = {},
	vue_ls = {
		capabilities = {
			textDocument = {
				colorProvider = { dynamicRegistration = false },
			},
		},
		settings = {
			vue = {
				updateImportsOnFileMove = { enabled = false },
			},
		},
	},

	vtsls = {
		filetypes = {
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
			"vue",
		},
		settings = {
			vtsls = {
				tsserver = {
					globalPlugins = { vue_plugin },
				},
			},
		},
		experimental = {
			completion = {
				enableServerSideFuzzyMatch = true,
				entriesLimit = 1000,
			},
		},
	},

	elixirls = {
		settings = {
			elixirLS = {
				dialyzerEnabled = true,
				fetchDeps = false,
			},
		},
	},

	eslint = {},
	dockerls = {},
	jsonls = {},
	html = {},
	cssls = {},
	emmet_language_server = {
		filetypes = { "css", "templ", "typescriptreact", "javascriptreact" },
		init_options = {
			showExpandedAbbreviation = "always",
			showSuggestionsAsSnippets = true,
		},
	},

	yamlls = {
		settings = {
			yaml = { validate = true },
		},
	},

	ruff = {
		on_attach = function(client, _)
			client.server_capabilities.hoverProvider = false
		end,
	},

	pyright = {
		settings = {
			python = {
				analysis = {
					typeCheckingMode = "basic",
					autoSearchPaths = true,
					useLibraryCodeForTypes = true,
					diagnosticMode = "openFilesOnly",
				},
			},
		},
	},

	tailwindcss = {
		filetypes = {
			"css",
			"vue",
			"svelte",
			"templ",
		},
		init_options = {
			userLanguages = { vue = "html" },
		},
		settings = {
			tailwindCSS = {
				validate = true,
				includeLanguages = {
					vue = "html",
					templ = "html",
				},
				classAttributes = { "class", "className", "class:list", "classList", "ngClass" },
				lint = {
					cssConflict = "warning",
					invalidApply = "error",
					invalidConfigPath = "error",
					invalidScreen = "error",
					invalidTailwindDirective = "error",
					invalidVariant = "error",
					recommendedVariantOrder = "warning",
				},
				experimental = {
					classRegex = {
						{ "tv\\(([^)]*)\\)", "[\"'`]([^\"'`]*)[\"'`]" },
						{ "tv\\{([^}]*)\\}", "[\"'`]([^\"'`]*)[\"'`]" },
					},
				},
			},
		},
	},
	gopls = {
		settings = {
			gopls = {
				analyses = {
					unusedparams = true,
					shadow = true,
					nilness = true,
					unusedwrite = true,
					fieldalignment = true,
				},
				staticcheck = true,
				gofumpt = true,
				usePlaceholders = true,
				hints = {
					assignVariableTypes = true,
					compositeLiteralFields = true,
					compositeLiteralTypes = true,
					constantValues = true,
					functionTypeParameters = true,
					parameterNames = true,
					rangeVariableTypes = true,
				},
			},
		},
	},
	htmx = {
		filetypes = { "php", "eelixir", "heex" },
	},
	templ = {},
}
