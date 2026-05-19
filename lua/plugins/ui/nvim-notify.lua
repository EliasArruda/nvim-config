return {
	"rcarriga/nvim-notify",
	lazy = true,
	opts = {
		-- 🎯 RENDER: simples, direto ao ponto
		render = "simple",
		-- 🎬 ANIMAÇÃO: fade_in_slide_out (preferência pessoal)
		stages = "fade_in_slide_out",
		-- ⏱️ TIMEOUT: 3s padrão, suficiente
		timeout = 3000,
		-- 📐 DIMENSÕES otimizadas
		max_width = 60,
		minimum_width = 10,
		-- 📍 POSIÇÃO: top_right (não interfere com código)
		position = "top_right",
		-- 🎨 FUNDO: transparente
		background_colour = "#000000",
		-- ⚡ FPS: 60 é suave sem sobrecarregar (default era 120!)
		fps = 60,
		-- 🔍 NÍVEL MÍNIMO: INFO (skip debug/trace)
		level = vim.log.levels.INFO,
		-- 🪟 BORDA/APARÊNCIA
		on_open = function(win)
			vim.api.nvim_win_set_config(win, { border = "rounded" })
			pcall(vim.api.nvim_win_set_option, win, "winblend", 12)
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
