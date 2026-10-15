return {
	"nvim-mini/mini.icons",
	opts = function()
		return require("config.icons").options()
	end,
	config = function(_, opts)
		require("mini.icons").setup(opts)
		require("config.icons").setup()
	end,
	init = function()
		package.preload["nvim-web-devicons"] = function()
			require("mini.icons").mock_nvim_web_devicons()
			return package.loaded["nvim-web-devicons"]
		end
	end,
}
