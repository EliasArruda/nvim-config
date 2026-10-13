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
				theme = "auto",
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
					{ function()
						local clients = vim.lsp.get_clients({ bufnr = 0 })
						local names = {}
						for _, client in ipairs(clients) do names[#names + 1] = client.name end
						return table.concat(names, " · ")
					end, cond = function() return vim.o.columns > 140 end },
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
