return {
	"akinsho/bufferline.nvim",
	version = "*",
	config = function()
		local bufferline = require("bufferline")

		bufferline.setup({
			options = {
				numbers = function()
					return ""
				end, -- remove números
				close_command = nil,
				right_mouse_command = nil,
				separator_style = "sloped",
				show_buffer_close_icons = false,
				show_close_icon = false,
				diagnostics = "nvim_lsp",
				always_show_bufferline = false, -- não mostra se houver só 1 buffer
			},
			highlights = (function()
				local colors = { fill = "#080c10", inactive = "#0a0c10", visible = "#0a0c10", selected = "#101419" }
				local highlights = {
					fill = { bg = colors.fill },
					offset_separator = { fg = "#252b32", bg = colors.fill },
					tab_separator = { fg = colors.fill, bg = colors.inactive },
					tab_separator_selected = { fg = colors.fill, bg = colors.selected },
					background = { fg = "#8894a5", bg = colors.inactive },
					tab = { fg = "#8894a5", bg = colors.inactive },
					tab_selected = { fg = "#d6deeb", bg = colors.selected, bold = true },
					tab_close = { bg = colors.inactive },
					group_label = { fg = "#8894a5", bg = colors.inactive },
					group_separator = { fg = "#343b44", bg = colors.fill },
					trunc_marker = { fg = "#8894a5", bg = colors.fill },
				}
				-- Icons, diagnostics, modified markers and separators share the tab's surface.
				for _, name in ipairs({
					"buffer",
					"numbers",
					"close_button",
					"diagnostic",
					"error",
					"error_diagnostic",
					"warning",
					"warning_diagnostic",
					"info",
					"info_diagnostic",
					"hint",
					"hint_diagnostic",
					"modified",
					"duplicate",
					"separator",

					"pick",
				}) do
					for suffix, bg in pairs({
						[""] = colors.inactive,
						_visible = colors.visible,
						_selected = colors.selected,
					}) do
						highlights[name .. suffix] = { bg = bg }
						if name == "separator" then
							highlights[name .. suffix].fg = colors.fill
						end
					end
				end
				highlights.buffer = { fg = "#8894a5", bg = colors.inactive }
				highlights.buffer_visible = { fg = "#a1aab8", bg = colors.visible }
				highlights.buffer_selected = { fg = "#d6deeb", bg = colors.selected, bold = true, italic = false }
				highlights.indicator_selected = { fg = "#82aaff", bg = colors.selected }
				highlights.indicator_visible = { fg = "#343b44", bg = colors.visible }
				return highlights
			end)(),
		})

		-- Mapeamento Alt + número para mudar de buffer
		for i = 1, 9 do
			vim.keymap.set("n", "<A-" .. i .. ">", function()
				require("bufferline").go_to_buffer(i, true)
			end, { desc = "Go to buffer " .. i, silent = true })
		end
	end,
}
