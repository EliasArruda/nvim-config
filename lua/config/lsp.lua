local M = {}
function M.setup(opts)
	vim.diagnostic.config({
		underline = true,
		update_in_insert = false,
		severity_sort = true,
		virtual_text = false,
		virtual_lines = { current_line = true },
		signs = opts.diagnostics.signs,
		float = { border = "rounded", source = "if_many" },
	})
	vim.api.nvim_create_user_command("LspInfo", function()
		vim.cmd("checkhealth vim.lsp")
	end, { force = true })
	vim.api.nvim_create_user_command("LspLog", function()
		vim.cmd.edit(vim.lsp.log.get_filename())
	end, { force = true })
	for name, action in pairs({ LspStop = "stop", LspRestart = "restart" }) do
		vim.api.nvim_create_user_command(name, function(info)
			vim.api.nvim_cmd({ cmd = "lsp", args = vim.list_extend({ action }, info.fargs) }, {})
		end, { nargs = "*", force = true })
	end
	vim.api.nvim_create_user_command("LspStart", function(info)
		if info.args ~= "" then
			vim.lsp.enable(info.args)
		else
			vim.api.nvim_exec_autocmds("FileType", { group = "nvim.lsp.enable", buffer = 0 })
		end
	end, { nargs = "?", force = true })
	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("core_lsp_attach", { clear = true }),
		callback = function(event)
			local client = vim.lsp.get_client_by_id(event.data.client_id)
			if not client then
				return
			end
			local keys = vim.list_extend({}, (opts.servers["*"] or {}).keys or {})
			vim.list_extend(keys, (opts.servers[client.name] or {}).keys or {})
			for _, map in ipairs(keys) do
				vim.keymap.set(map.mode or "n", map[1], map[2], { buffer = event.buf, silent = true, desc = map.desc })
			end
			if require("config.runtime").is_large(event.buf) then
				return
			end
			if
				opts.inlay_hints.enabled
				and client:supports_method("textDocument/inlayHint", event.buf)
				and not vim.tbl_contains(opts.inlay_hints.exclude or {}, vim.bo[event.buf].filetype)
			then
				vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
			end
			if opts.codelens.enabled and client:supports_method("textDocument/codeLens", event.buf) then
				vim.lsp.codelens.enable(true, { bufnr = event.buf, client_id = client.id })
			end
		end,
	})
	local capabilities = require("blink.cmp").get_lsp_capabilities()
	for name, server in pairs(opts.servers) do
		if name ~= "*" and server ~= false and not (type(server) == "table" and server.enabled == false) then
			server = server == true and {} or vim.deepcopy(server)
			server.capabilities = vim.tbl_deep_extend(
				"force",
				(opts.servers["*"] or {}).capabilities or {},
				capabilities,
				server.capabilities or {}
			)
			local inherited = vim.lsp.config[name] or {}
			local original_root = server.root_dir or inherited.root_dir
			local root_markers = server.root_markers or inherited.root_markers
			server.root_dir = function(buf, on_dir)
				if require("config.runtime").is_large(buf) then
					return
				end
				local project = require("core.project").root(buf)
				if type(original_root) == "function" then
					original_root(buf, function(root)
						if root == vim.env.HOME and project ~= root then
							return
						end
						on_dir(root)
					end)
				else
					on_dir(require("core.project").root(buf, root_markers))
				end
			end
			vim.lsp.config(name, server)
			vim.lsp.enable(name)
		end
	end
end
return M
