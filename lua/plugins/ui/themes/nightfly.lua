return {
	"bluz71/vim-nightfly-colors",
	name = "nightfly",
	lazy = false,
	priority = 1000,
	init = function()
		vim.g.nightflyItalics = false
		vim.g.nightflyTransparent = false
		vim.g.nightflyNormalPmenu = true
		vim.g.nightflyNormalFloat = true
	end,
	config = function()
		vim.o.background = "dark"
		vim.cmd.colorscheme(require("config.settings").colorscheme)
	end,
}
