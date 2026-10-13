return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",

	init = function()
		vim.opt.laststatus = 3
		vim.g.lualine_laststatus = 3
	end,

	config = function()
		local lualine = require("lualine")

		lualine.setup({
			options = {
				theme = (function()
					local theme = vim.deepcopy(require("lualine.themes.nightfly"))
					for _, mode in pairs(theme) do
						for section, hl in pairs(mode) do
							if section == "b" then
								hl.bg = "#222e3c"
							elseif section == "c" then
								hl.bg = mode == theme.inactive and "#10151b" or "#161d26"
							end
							if section == "a" then
								hl.fg = "#080c10"
							end
						end
					end
					return theme
				end)(),
				globalstatus = true,
			},

			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch" },

				lualine_c = {
					{ "diagnostics" },
					{
						"filename",
						path = 1,
						fmt = function(str)
							if str:find("%[No Name%]") then
								return ""
							end
							return str:gsub("%s%[%s?[-+]%s?%]$", "")
						end,
					},
				},

				lualine_x = {
					{
						function()
							local clients = vim.lsp.get_clients({ bufnr = 0 })
							local names = {}
							for _, client in ipairs(clients) do
								names[#names + 1] = client.name
							end
							return table.concat(names, " · ")
						end,
						cond = function()
							return vim.o.columns > 140
						end,
					},
					"filetype",
				},

				lualine_y = { "progress" },
				lualine_z = {
					function()
						return vim.fn.fnamemodify(require("core.project").root(), ":t")
					end,
				},
			},
		})
	end,
}
