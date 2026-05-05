return {
	"nvim-mini/mini.icons",
	lazy = true,
	opts = {
		extension = {
			razor = { glyph = "﹫", hl = "MiniIconsPurple" }, -- Blazor Components (.razor)
			cshtml = { glyph = "﹫", hl = "MiniIconsPurple" }, -- MVC/Razor Pages (.cshtml)
			csproj = { glyph = "󰪮", hl = "MiniIconsOrange" }, -- C# Project (.csproj)
			sln = { glyph = "󰪮", hl = "MiniIconsOrange" }, -- Solution (.sln)

			ts = { hl = "MiniIconsMarine" },
		},
		file = {
			[".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
			["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
			["Cargo.toml"] = { glyph = "🦀", hl = "MiniIconsOrange" },
			["package.json"] = { glyph = "󰎙", hl = "MiniIconsGreen" },
			["tsconfig.json"] = { glyph = "󰛦", hl = "MiniIconsBlue" },
		},
		filetype = {
			dotenv = { glyph = "", hl = "MiniIconsYellow" },
		},
	},
	init = function()
		package.preload["nvim-web-devicons"] = function()
			require("mini.icons").mock_nvim_web_devicons()
			return package.loaded["nvim-web-devicons"]
		end
	end,
}
