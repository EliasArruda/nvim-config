return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	config = function()
		local autopairs = require("nvim-autopairs")

		autopairs.setup({
			check_ts = true, -- Ativa a integração com o Treesitter que você já tem configurado
			disable_filetype = { "TelescopePrompt", "vim" },
		})
	end,
}
