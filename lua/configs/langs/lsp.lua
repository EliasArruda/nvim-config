local function project_root(buf, on_dir)
	on_dir(require("core.project").root(buf))
end

local function get_vue_language_server_path()
	return vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
end

local vue_plugin = {
	name = "@vue/typescript-plugin",
	location = get_vue_language_server_path(),
	languages = { "vue" },
	configNamespace = "typescript",
	enableForWorkspaceTypeScriptVersions = true,
}

local ruby_lsp_wrapper = vim.fn.stdpath("config") .. "/bin/ruby-lsp"

return {
	clangd = {
		cmd = {
			"clangd",
			"--background-index",
			"--clang-tidy",
			"--completion-style=detailed",
			"--header-insertion=iwyu",
		},
		root_dir = function(buf, on_dir)
			on_dir(require("core.project").root(buf, { ".clangd", "compile_commands.json", "compile_flags.txt", "Makefile", "meson.build" }))
		end,
	},
	sqls = {},
	taplo = {},
	bicep = { cmd = { "bicep-lsp" } },
	svelte = {},
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
		root_dir = project_root,
		filetypes = {
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
			"vue",
		},
		settings = {
			vtsls = {
				autoUseWorkspaceTsdk = true,
				enableMoveToFileCodeAction = false,
				experimental = { completion = { enableServerSideFuzzyMatch = true, entriesLimit = 1000 } },
				tsserver = {
					globalPlugins = { vue_plugin },
				},
			},
			typescript = {
				updateImportsOnFileMove = { enabled = "always" },
				suggest = { completeFunctionCalls = true },
				preferences = {
					includePackageJsonAutoImports = "auto",
					importModuleSpecifier = "shortest",
					preferTypeOnlyAutoImports = true,
				},
				inlayHints = {
					parameterNames = { enabled = "literals" },
					parameterTypes = { enabled = true },
					variableTypes = { enabled = false },
					propertyDeclarationTypes = { enabled = true },
					functionLikeReturnTypes = { enabled = true },
					enumMemberValues = { enabled = true },
				},
				tsserver = { maxTsServerMemory = 4096 },
			},
			javascript = {
				updateImportsOnFileMove = { enabled = "always" },
				suggest = { completeFunctionCalls = true },
				preferences = {
					includePackageJsonAutoImports = "auto",
					importModuleSpecifier = "shortest",
				},
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

	eslint = {
		settings = {
			workingDirectory = { mode = "auto" },
			format = false,
			quiet = false,
			run = "onType",
			useFlatConfig = nil,
		},
	},
	dockerls = {},
	jsonls = { settings = { json = { schemas = require("schemastore").json.schemas(), validate = { enable = true } } } },
	html = { root_dir = project_root },
	cssls = {
		root_dir = project_root,
		settings = {
			css = {
				validate = true,
				lint = {
					emptyRules = "warning",
					importStatement = "warning",
					duplicateProperties = "warning",
					zeroUnits = "warning",
					fontFaceProperties = "warning",
					hexColorLength = "warning",
					idSelector = "warning",
					important = "warning",
					propertyIgnoredDueToDisplay = "warning",
					universalSelector = "warning",
					unknownVendorSpecificProperties = "warning",
					unknownAtRules = "warning",
					compatibleVendorPrefixes = "warning",
					vendorPrefix = "warning",
					argumentsInColorFunction = "warning",
					boxModel = "warning",
					float = "warning",
					unitAlignment = "warning",
				},
			},
			scss = {
				validate = true,
				lint = {
					emptyRules = "warning",
					importStatement = "warning",
					duplicateProperties = "warning",
					zeroUnits = "warning",
					fontFaceProperties = "warning",
					hexColorLength = "warning",
					idSelector = "warning",
					important = "warning",
					propertyIgnoredDueToDisplay = "warning",
					universalSelector = "warning",
					unknownVendorSpecificProperties = "warning",
					unknownAtRules = "warning",
					compatibleVendorPrefixes = "warning",
					vendorPrefix = "warning",
					argumentsInColorFunction = "warning",
					boxModel = "warning",
					float = "warning",
					unitAlignment = "warning",
				},
			},
			less = {
				validate = true,
				lint = {
					emptyRules = "warning",
					importStatement = "warning",
					duplicateProperties = "warning",
					zeroUnits = "warning",
					fontFaceProperties = "warning",
					hexColorLength = "warning",
					idSelector = "warning",
					important = "warning",
					propertyIgnoredDueToDisplay = "warning",
					universalSelector = "warning",
					unknownVendorSpecificProperties = "warning",
					unknownAtRules = "warning",
					compatibleVendorPrefixes = "warning",
					vendorPrefix = "warning",
					argumentsInColorFunction = "warning",
					boxModel = "warning",
					float = "warning",
					unitAlignment = "warning",
				},
			},
		},
		init_options = {
			provideFormatter = true,
		},
	},
	emmet_language_server = {
		root_dir = project_root,
		filetypes = { "css", "html", "razor", "templ", "vue", "typescriptreact", "javascriptreact" },
		init_options = {
			includeLanguages = {
				razor = "html",
				vue = "html",
			},
			showExpandedAbbreviation = "always",
			showAbbreviationSuggestions = true,
			showSuggestionsAsSnippets = true,
		},
	},

	yamlls = {
		settings = {
			yaml = { validate = true, schemaStore = { enable = false, url = "" }, schemas = require("schemastore").yaml.schemas() },
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
		root_dir = function(buf, on_dir)
			local root = require("core.project").root(buf)
			local configs = vim.fn.glob(root .. "/tailwind.config.*", false, true)
			local package = root .. "/package.json"
			local ok, data = pcall(function() return vim.json.decode(table.concat(vim.fn.readfile(package), "\n")) end)
			local deps = ok and type(data) == "table" and vim.tbl_extend("force", data.dependencies or {}, data.devDependencies or {}) or {}
			if #configs > 0 or deps.tailwindcss then on_dir(root) end
		end,
		filetypes = {
			"aspnetcorerazor",
			"astro",
			"css",
			"html",
			"htmlangular",
			"javascript",
			"javascriptreact",
			"razor",
			"svelte",
			"typescript",
			"typescriptreact",
			"vue",
		},
		cmd = function(dispatchers, config)
			local cmd = "tailwindcss-language-server"
			if (config or {}).root_dir then
				local local_cmd = vim.fs.joinpath(config.root_dir, "node_modules/.bin", cmd)
				if vim.fn.executable(local_cmd) == 1 then
					cmd = local_cmd
				end
			end
			return vim.lsp.rpc.start({ cmd, "--stdio" }, dispatchers)
		end,
		settings = {
			tailwindCSS = {
				validate = true,
				emmetCompletions = true,
				includeLanguages = {
					razor = "html",
					vue = "html",
				},
				classAttributes = { "class", "className", "class:list", "classList", "ngClass" },
				classFunctions = { "cn", "clsx", "cva", "cx", "tw", "tw\\.[a-z-]+" },
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

	gopls = {
		settings = {
			gopls = {
				completeFunctionCalls = true,
				analyses = {
					unusedparams = true,
					shadow = true,
					nilness = true,
					unusedwrite = true,
				},
				staticcheck = true,
				gofumpt = true,
				usePlaceholders = true,
				vulncheck = "Imports",
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

	-- Ruby LSP discovers the project's Gemfile and activates Rails support
	-- through ruby-lsp-rails (included in Mason's ruby-lsp package).
	ruby_lsp = {
		filetypes = { "ruby", "eruby" },
		-- The wrapper asks mise for the Ruby selected by the project. Ruby LSP
		-- then composes .ruby-lsp/Gemfile against that project's bundle.
		cmd = { ruby_lsp_wrapper },
		init_options = {
			formatter = "auto",
			erbSupport = true,
			addonSettings = {
				["Ruby LSP Rails"] = {
					enablePendingMigrationsPrompt = false,
				},
			},
		},
	},
}
