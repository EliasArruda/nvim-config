-- Explicit font integration check; ordinary headless checks keep terminal fallback.
local icons = require("config.icons")
local mini = require("mini.icons")
local data =
	vim.json.decode(table.concat(vim.fn.readfile(vim.fn.stdpath("config") .. "/data/symbols-icons.json"), "\n"))
vim.g.neovide = true
assert(icons.using_font(), "Matching Symbols font must be installed")
mini.setup(icons.options())
local mappings = 0
for _, category in ipairs({ "file", "extension", "directory", "filetype" }) do
	for name, id in pairs(data[category]) do
		local glyph = mini.get(category, name)
		assert(glyph == vim.fn.nr2char(data.catalog[id].codepoint), category .. " " .. name .. " loses Symbols glyph")
		assert(vim.fn.strdisplaywidth(glyph) == 1, "Glyph width must fit Neovim layout")
		mappings = mappings + 1
	end
end
local old = vim.g.symbols_icons_font
vim.g.symbols_icons_font = false
assert(not icons.using_font(), "Opt-out must select compatible Nerd Font fallback")
assert(icons.gui_font() == "JetBrainsMono Nerd Font:h16", "Primary text font preserved")
vim.g.symbols_icons_font = old
local env = vim.env.XDG_DATA_HOME
local temporary = vim.fn.tempname()
vim.env.XDG_DATA_HOME = temporary
package.loaded["config.icons"] = nil
assert(not require("config.icons").using_font(), "Missing font falls back safely")
local font_dir = temporary .. "/fonts/nvim-symbols"
vim.fn.mkdir(font_dir, "p")
vim.fn.writefile({ "" }, font_dir .. "/NeovimSymbols-Regular.ttf")
vim.fn.writefile({ "not valid json" }, font_dir .. "/NeovimSymbols-Regular.json")
package.loaded["config.icons"] = nil
assert(not require("config.icons").using_font(), "Malformed font metadata falls back safely")
vim.fn.writefile(
	{ vim.json.encode({ signature = "obsolete", renderer = "resvg-sbix-v1" }) },
	font_dir .. "/NeovimSymbols-Regular.json"
)
package.loaded["config.icons"] = nil
assert(not require("config.icons").using_font(), "Stale font falls back safely")
vim.env.XDG_DATA_HOME = env
package.loaded["config.icons"] = icons
vim.fn.delete(temporary, "rf")
print(("PASS: %d Symbols mappings use original SVG font glyphs"):format(mappings))
