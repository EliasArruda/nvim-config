local mini = require("mini.icons")
local checks = 0
local function check(value, label)
	assert(value, label)
	checks = checks + 1
end
local function color(category, name)
	local _, hl = mini.get(category, name)
	return vim.api.nvim_get_hl(0, { name = hl, link = false }).fg
end
check(color("file", "Program.cs") == 0x14B8A6, "Symbols C# color")
check(color("file", "Home.razor") == 0x14B8A6, "Symbols Razor color")
check(select(1, mini.get("file", "Home.razor")) == "", "Supported Razor at glyph")
check(color("file", "appsettings.json") == 0xF59E0B, "Symbols JSON color")
check(color("file", "App.vue") == 0x14B8A6, "Language ID fallback for Vue")
check(color("file", "main.ts") == 0x2563EB, "Symbols TypeScript color")
check(color("file", "package.json") == 0x2DD4BF, "Named file wins over JSON extension")
check(color("directory", "/project/Components") == 0x16A34A, "Capitalized .NET folder alias")
check(color("directory", "/project/Pages") == 0x0EA5E9, "Symbols Pages color")
local devicons = require("nvim-web-devicons")
local glyph, rgb = devicons.get_icon_color("Program.cs", "cs", { default = true })
check(
	glyph == select(1, mini.get("file", "Program.cs")) and rgb:lower() == "#14b8a6",
	"Devicons consumers share Symbols"
)
vim.cmd.colorscheme("nightfly")
check(color("file", "Program.cs") == 0x14B8A6, "Symbols colors persist after colorscheme reload")
check(vim.api.nvim_get_hl(0, { name = "Normal", link = false }).bg == 0x080C10, "Dark editor background preserved")
check(vim.fn.exists(":SymbolsIcons") == 2, "Symbols preview command")
local icons = require("config.icons")
local path_glyph, path_hl = icons.completion_icon({ kind = "File", item = { label = "Home.razor" } })
check(
	path_glyph == select(1, mini.get("file", "Home.razor")) and path_hl == select(2, mini.get("file", "Home.razor")),
	"Path completion shares Razor icon and color"
)
local semantic, semantic_hl = icons.completion_icon({ kind = "Method", kind_icon = "", item = { label = "Save" } })
check(semantic == "" and semantic_hl == "BlinkCmpKindMethod", "Semantic completion icons stay intact")
vim.cmd("SymbolsIcons all")
local snapshot =
	vim.json.decode(table.concat(vim.fn.readfile(vim.fn.stdpath("config") .. "/data/symbols-icons.json"), "\n"))
check(vim.api.nvim_buf_line_count(0) == vim.tbl_count(snapshot.catalog) + 3, "Complete catalog includes every SVG")
vim.cmd("close")
print(("PASS: %d icon checks"):format(checks))
