return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"saghen/blink.cmp",
		"b0o/SchemaStore.nvim",
	},
	opts_extend = { "servers.*.keys" },
	opts = function()
		---@class PluginLspOpts
		local lang_servers = require("configs.langs.lsp")
		local ret = {
			diagnostics = {
				underline = true,
				update_in_insert = false,
				virtual_text = {
					spacing = 4,
					source = "if_many",
					prefix = "●",
				},
				severity_sort = true,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚",
						[vim.diagnostic.severity.WARN] = "󰀪",
						[vim.diagnostic.severity.HINT] = "󰌶",
						[vim.diagnostic.severity.INFO] = "󰋼",
					},
				},
			},
			inlay_hints = {
				enabled = true,
				exclude = { "vue" },
			},
			codelens = {
				enabled = true,
			},
			servers = vim.tbl_deep_extend("force", {
				["*"] = {
					capabilities = {
						workspace = {
							fileOperations = {
								didRename = true,
								willRename = true,
							},
						},
					},
					keys = {
						{ "gd", require("telescope.builtin").lsp_definitions, desc = "Definition" },
						{ "gD", vim.lsp.buf.declaration, desc = "Declaration" },
						{ "gI", require("telescope.builtin").lsp_implementations, desc = "Implementation" },
						{ "gy", require("telescope.builtin").lsp_type_definitions, desc = "Type definition" },
						{ "gr", require("telescope.builtin").lsp_references, desc = "References" },
						{ "K", vim.lsp.buf.hover, desc = "Hover" },
						{ "<leader>ca", vim.lsp.buf.code_action, mode = { "n", "x" }, desc = "Code action" },
						{ "<leader>cr", vim.lsp.buf.rename, desc = "Rename" },
					},
				},
				lua_ls = {
					settings = {
						Lua = {
							workspace = { checkThirdParty = false },
							hint = { enable = true },
						},
					},
				},
			}, lang_servers),
		}
		return ret
	end,
	config = function(_, opts)
		require("config.lsp").setup(opts)
	end,
}
