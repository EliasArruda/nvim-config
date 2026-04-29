return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",

	init = function()
		-- Define a statusline global para evitar repetição em cada janela
		vim.opt.laststatus = 3
		vim.g.lualine_laststatus = 3

		if vim.fn.argc(-1) > 0 then
			vim.o.statusline = " "
		else
			vim.o.laststatus = 0
		end
	end,

	config = function()
		local lualine = require("lualine")

		lualine.setup({
			options = {
				theme = "auto",
				globalstatus = true, -- Ativa a barra única na parte inferior
			},

			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch" },

				lualine_c = {
					{ "diagnostics" },
					{
						"filename",
						path = 1,
						-- FUNÇÃO PARA LIMPAR O [No Name] E O [-]
						fmt = function(str)
							-- Se for um buffer sem nome, retorna vazio
							if str:find("%[No Name%]") then
								return ""
							end
							-- Remove o indicador de modificado [ - ] ou [ + ] do final da string
							return str:gsub("%s%[%s?[-+]%s?%]$", "")
						end,
					},
				},

				lualine_x = {
					"encoding",
					"fileformat",
					"filetype",
				},

				lualine_y = { "progress" },
				lualine_z = {
					function()
						return " " .. os.date("%R")
					end,
				},
			},
		})
	end,
}
