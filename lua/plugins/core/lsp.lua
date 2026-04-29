return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"mason.nvim",
		{ "williamboman/mason-lspconfig.nvim", config = function() end },
		"Saghen/blink.cmp",
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
	                                        [vim.diagnostic.severity.ERROR] = "",
	                                        [vim.diagnostic.severity.WARN] = "",
	                                        [vim.diagnostic.severity.HINT] = "",
	                                        [vim.diagnostic.severity.INFO] = "",
	                                },
	                        },
	                },
	                inlay_hints = {
	                        enabled = true,
	                        exclude = { "vue" },
	                },
	                codelens = {
	                        enabled = false,
	                },
	                folds = {
	                        enabled = true,
	                },
	                format = {
	                        formatting_options = nil,
	                        timeout_ms = nil,
	                },
	                servers = vim.tbl_deep_extend(
	                        "force",
	                        {
	                                ["*"] = {
	                                        capabilities = {
	                                                workspace = {
	                                                        fileOperations = {
	                                                                didRename = true,
	                                                                willRename = true,
	                                                        },
	                                                },
	                                        },
	                                        -- Global Keymaps with Professional English Descriptions
	                                        keys = {
	                                                { "gr", require("telescope.builtin").lsp_references, desc = "References" },
	                                                { "<leader>cr", vim.lsp.buf.rename, desc = "Rename" },
	                                                {
	                                                        "<leader>cf",
	                                                        function()
	                                                                vim.lsp.buf.format({ async = true })
	                                                        end,
	                                                        desc = "Format Buffer",
	                                                },
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
	                        },
	                        lang_servers
	                ),
	                setup = {},
	        }
	        return ret
	end,
	config = function(_, opts)
		-- 1. Diagnósticos
		vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

		-- 2. Capabilities do Blink.cmp
		local blink_capabilities = require("blink.cmp").get_lsp_capabilities()

		-- 3. Lógica de Keymaps e Recursos (LspAttach)
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local bufnr = args.buf
				local client = vim.lsp.get_client_by_id(args.data.client_id)

				-- Keymaps
				local all_keys = {}
				if opts.servers["*"] and opts.servers["*"].keys then
					vim.list_extend(all_keys, opts.servers["*"].keys)
				end

				local server_name = client.name
				if opts.servers[server_name] and opts.servers[server_name].keys then
					vim.list_extend(all_keys, opts.servers[server_name].keys)
				end

				for _, map in ipairs(all_keys) do
					local mode = map.mode or "n"
					local lhs = map[1]
					local rhs = map[2]
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = map.desc })
				end

				-- Inlay Hints
				if opts.inlay_hints.enabled and client.server_capabilities.inlayHintProvider then
					vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
				end

				-- Folds (CORRIGIDO AQUI)
				if opts.folds.enabled and client.server_capabilities.foldingRangeProvider then
					vim.opt_local.foldmethod = "expr"
					vim.opt_local.foldexpr = "v:lua.vim.lsp.foldexpr()"
				end
			end,
		})

		-- 4. Configuração dos Servidores (API Neovim 0.11)
		local servers_to_setup = vim.tbl_keys(opts.servers)

		for _, name in ipairs(servers_to_setup) do
			if name == "*" then
				goto continue
			end

			local server_opts = opts.servers[name]
			if type(server_opts) == "boolean" then
				server_opts = server_opts and {} or { enabled = false }
			end

			if server_opts.enabled == false then
				goto continue
			end

			local capabilities = vim.tbl_deep_extend(
				"force",
				opts.servers["*"] and opts.servers["*"].capabilities or {},
				blink_capabilities
			)

			server_opts.capabilities = capabilities

			vim.lsp.config(name, server_opts)
			vim.lsp.enable(name)

			::continue::
		end

		-- 5. Mason-lspconfig
		require("mason-lspconfig").setup({
		        ensure_installed = vim.tbl_filter(function(name)
		                return name ~= "*" and name ~= "roslyn" and (opts.servers[name] ~= false)
		        end, servers_to_setup),
		})

	end,
}
