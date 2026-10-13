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
			highlights = {
				background = { fg = "#8894a5", bg = "#10151b" },
				buffer_selected = {
					fg = "#d6deeb",
					bg = "#1c2633",
					bold = true,
				},
				indicator_selected = {
					fg = "#82aaff",
					bg = "#1c2633",
				},
				fill = {
					bg = "#080c10",
				},
			},
		})

		-- Mapeamento Alt + número para mudar de buffer
		for i = 1, 9 do
			vim.keymap.set("n", "<A-" .. i .. ">", function()
				require("bufferline").go_to_buffer(i, true)
			end, { desc = "Go to buffer " .. i, silent = true })
		end
	end,
}
