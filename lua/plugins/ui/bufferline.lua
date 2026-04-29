return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = { "nvim-tree/nvim-web-devicons" },
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
				buffer_selected = {
					fg = "#FFA500",
					sp = "#ff5555", -- vermelho
				},
				indicator_selected = {
					fg = "#ff5555",
					sp = "#ff5555", -- vermelho
				},
				fill = {
					bg = "NONE", -- fundo limpo
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
