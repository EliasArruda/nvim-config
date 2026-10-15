return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	config = function()
		local autopairs = require("nvim-autopairs")

		autopairs.setup({
			check_ts = true, -- Ativa a integração com o Treesitter que você já tem configurado
			disable_filetype = { "TelescopePrompt", "vim" },
		})
		local Rule = require("nvim-autopairs.rule")
		autopairs.add_rule(Rule(">", "</", "razor")
			:with_pair(function()
				return false
			end)
			:with_move(function()
				return false
			end)
			:with_del(function()
				return false
			end)
			:with_cr(function()
				return require("config.razor-editing").between_tags()
			end)
			:replace_map_cr(function()
				return "<C-g>u<Cmd>lua require('config.razor-editing').split()<CR>"
			end))
	end,
}
