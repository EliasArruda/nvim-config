return {
	{
		"nvim-treesitter/nvim-treesitter",
		init = function()
			require("configs.langs.razor").setup()
		end,
	},
	{
		"saghen/blink.cmp",
		opts = function(_, opts)
			local razor = require("configs.langs.razor")
			opts.completion = opts.completion or {}
			opts.completion.trigger = opts.completion.trigger or {}
			local blocked = opts.completion.trigger.show_on_blocked_trigger_characters
			opts.completion.trigger.show_on_blocked_trigger_characters = function()
				if vim.bo.filetype == "razor" then
					return razor.in_tag() and { "\n", "\t" } or { " ", "\n", "\t" }
				end
				return type(blocked) == "function" and blocked() or blocked or { " ", "\n", "\t" }
			end
			opts.completion.list = opts.completion.list or {}
			opts.completion.list.selection = opts.completion.list.selection or {}
			for _, key in ipairs({ "preselect", "auto_insert" }) do
				local previous = opts.completion.list.selection[key]
				opts.completion.list.selection[key] = function(ctx)
					if vim.bo[ctx.bufnr].filetype == "razor" then
						return false
					end
					if type(previous) == "function" then
						return previous(ctx)
					end
					return previous ~= false
				end
			end
			opts.sources = opts.sources or {}
			opts.sources.providers = opts.sources.providers or {}
			opts.sources.providers.lsp = opts.sources.providers.lsp or {}
			local provider = opts.sources.providers.lsp
			local transform = provider.transform_items
			provider.transform_items = function(context, items)
				if transform then
					items = transform(context, items)
				end
				if vim.bo[context.bufnr].filetype ~= "razor" then
					return items
				end
				local result = {}
				local code = razor.is_code_or_comment(context.bufnr, context.cursor)
				for _, item in ipairs(items) do
					if item.client_name ~= "emmet_language_server" then
						result[#result + 1] = item
					elseif not code then
						item.score_offset = (item.score_offset or 0) + 25
						result[#result + 1] = item
					end
				end
				return result
			end
			provider.override = provider.override or {}
			local previous = provider.override.get_completions
			provider.override.get_completions = function(self, context, callback)
				if vim.bo[context.bufnr].filetype == "razor" then
					if context.trigger.character == " " and razor.in_tag(context.bufnr, context.cursor) then
						context = vim.deepcopy(context)
						context.trigger.kind, context.trigger.character = "manual", nil
					end
					return self:get_completions(context, callback)
				end
				if previous then
					return previous(self, context, callback)
				end
				return self:get_completions(context, callback)
			end
		end,
	},
}
