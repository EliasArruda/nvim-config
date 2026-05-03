return {
	"rcarriga/nvim-notify",
	lazy = true,
	opts = {
		render = "simple",
		stages = "fade_in_slide_out",
		timeout = 3000,
		max_width = 60,
		minimum_width = 10,
		top_down = true, -- <-- mude aqui
		position = "top_right", -- <-- adicione esta linha
		background_colour = "#000000",
		fps = 120,
		level = vim.log.levels.INFO,
		on_open = function(win)
			vim.api.nvim_win_set_config(win, { border = "rounded" })
		end,
	},
	config = function(_, opts)
		local notify = require("notify")
		notify.setup(opts)
		vim.notify = notify

		-- 🎨 Highlights transparentes nas notificações
		local overrides = {
			NotifyERRORBorder = { fg = "#E06C75", bg = "NONE" },
			NotifyWARNBorder = { fg = "#D19A66", bg = "NONE" },
			NotifyINFOBorder = { fg = "#98C379", bg = "NONE" },
			NotifyDEBUGBorder = { fg = "#5C6370", bg = "NONE" },
			NotifyTRACEBorder = { fg = "#C678DD", bg = "NONE" },
			NotifyERRORIcon = { fg = "#E06C75", bg = "NONE" },
			NotifyWARNIcon = { fg = "#D19A66", bg = "NONE" },
			NotifyINFOIcon = { fg = "#98C379", bg = "NONE" },
			NotifyDEBUGIcon = { fg = "#5C6370", bg = "NONE" },
			NotifyTRACEIcon = { fg = "#C678DD", bg = "NONE" },
			NotifyERRORTitle = { fg = "#E06C75", bg = "NONE", bold = true },
			NotifyWARNTitle = { fg = "#D19A66", bg = "NONE", bold = true },
			NotifyINFOTitle = { fg = "#98C379", bg = "NONE", bold = true },
			NotifyDEBUGTitle = { fg = "#5C6370", bg = "NONE", bold = true },
			NotifyTRACETitle = { fg = "#C678DD", bg = "NONE", bold = true },
			NotifyERRORBody = { bg = "NONE" },
			NotifyWARNBody = { bg = "NONE" },
			NotifyINFOBody = { bg = "NONE" },
			NotifyDEBUGBody = { bg = "NONE" },
			NotifyTRACEBody = { bg = "NONE" },
		}
		for group, colors in pairs(overrides) do
			vim.api.nvim_set_hl(0, group, colors)
		end
	end,
}
