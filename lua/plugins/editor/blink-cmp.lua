return {
	{
		"saghen/blink.cmp",
		dependencies = "rafamadriz/friendly-snippets",
		version = "1.*",
		lazy = false,
		opts = {
			enabled = function()
				if require("config.runtime").is_large(0) or vim.bo.buftype ~= "" then
					return false
				end
				if vim.bo.filetype == "netrw" then
					return false
				end
				if vim.bo.filetype == "TelescopePrompt" then
					return false
				end
				return true
			end,
			appearance = {
				nerd_font_variant = "mono",
				kind_icons = {
					Text = "",
					Method = "",
					Function = "",
					Constructor = "",
					Field = "",
					Variable = "",
					Class = "",
					Interface = "",
					Module = "",
					Property = "",
					Unit = "",
					Value = "",
					Enum = "",
					Keyword = "",
					Snippet = "",
					Color = "",
					File = "",
					Reference = "",
					Folder = "",
					EnumMember = "",
					Constant = "",
					Struct = "",
					Event = "",
					Operator = "",
					TypeParameter = "",
				},
			},
			keymap = {
				preset = "none",
				["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-e>"] = { "hide", "fallback" },
				["<CR>"] = { "accept", "fallback" },
				["<Tab>"] = { "snippet_forward", "select_and_accept", "fallback" },
				["<S-Tab>"] = { "snippet_backward", "fallback" },
				["<Up>"] = { "select_prev", "fallback" },
				["<Down>"] = { "select_next", "fallback" },
				["<C-p>"] = { "select_prev", "fallback" },
				["<C-n>"] = { "select_next", "fallback" },
				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },
				["<C-d>"] = { "scroll_documentation_down", "fallback" },
				["<C-u>"] = { "scroll_documentation_up", "fallback" },
			},
			signature = { enabled = false },
			completion = {
				trigger = {
					show_on_blocked_trigger_characters = function()
						-- HTML attributes are requested after a space; Blink blocks it
						-- globally by default. Restrict this exception to Razor tags.
						if vim.bo.filetype == "razor" then
							local col = vim.api.nvim_win_get_cursor(0)[2]
							local before = vim.api.nvim_get_current_line():sub(1, col)
							if before:match("<[%w_:.-][^>]*$") then
								return { "\n", "\t" }
							end
						end
						return { " ", "\n", "\t" }
					end,
				},
				keyword = { range = "full" },
				ghost_text = { enabled = true },
				list = { selection = { preselect = true, auto_insert = true } },
				menu = {
					border = "rounded",
					scrollbar = false,
					draw = {
						columns = { { "kind_icon", "label", gap = 1 }, { "kind" } },
						components = {
							kind_icon = {
								text = function(ctx)
									local glyph = require("config.icons").completion_icon(ctx)
									return glyph .. ctx.icon_gap
								end,
								highlight = function(ctx)
									local _, hl = require("config.icons").completion_icon(ctx)
									return { { group = hl, priority = 20000 } }
								end,
							},
						},
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 230,
					window = { border = "rounded", scrollbar = false, min_width = 55, max_width = 55, max_height = 12 },
				},
				accept = { auto_brackets = { enabled = true } },
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
				per_filetype = { razor = { inherit_defaults = true, "emmet" } },
				providers = {
					emmet = { name = "Emmet", module = "config.sources.emmet", async = true, score_offset = 35 },
					lsp = {
						async = true,
						timeout_ms = 350,
						score_offset = 10,
						override = {
							get_completions = function(self, context, callback)
								-- Roslyn advertises space, but the delegated HTML server
								-- needs an Invoked request to return standard attributes.
								if vim.bo.filetype == "razor" and context.trigger.character == " " then
									context = vim.deepcopy(context)
									context.trigger.kind = "manual"
									context.trigger.character = nil
								end
								return self:get_completions(context, callback)
							end,
						},
					},
					path = { score_offset = 5 },
					snippets = { score_offset = 0 },
					buffer = { score_offset = -5 },
				},
			},
		},
		config = function(_, opts)
			require("blink.cmp").setup(opts)
			local kind_colors = {
				Text = "#98c379",
				Method = "#b87ce6",
				Function = "#b87ce6",
				Constructor = "#b87ce6",
				Field = "#d19a66",
				Variable = "#61afef",
				Class = "#4EC9B0",
				Interface = "#4EC9B0",
				Module = "#e5c07b",
				Property = "#d19a66",
				Unit = "#98c379",
				Value = "#98c379",
				Enum = "#98c379",
				Keyword = "#c678dd",
				Snippet = "#fca2aa",
				Color = "#e06c75",
				File = "#56b6c2",
				Reference = "#61afef",
				Folder = "#56b6c2",
				EnumMember = "#98c379",
				Constant = "#d19a66",
				Struct = "#4EC9B0",
				Event = "#e06c75",
				Operator = "#56b6c2",
				TypeParameter = "#4EC9B0",
			}
			local function apply_colors()
				for kind, fg in pairs(kind_colors) do
					vim.api.nvim_set_hl(0, "BlinkCmpKind" .. kind, { fg = fg })
				end
			end
			apply_colors()
			vim.api.nvim_create_autocmd(
				"ColorScheme",
				{ group = vim.api.nvim_create_augroup("blink_kind_colors", { clear = true }), callback = apply_colors }
			)
		end,
	},
}
