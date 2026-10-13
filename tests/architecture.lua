local checks = 0
local function check(value, label)
	assert(value, label)
	checks = checks + 1
end
local dir = vim.fn.tempname()
vim.fn.mkdir(dir .. "/repo/apps/web/src", "p")
vim.fn.mkdir(dir .. "/repo/server/Components/Pages", "p")
vim.fn.mkdir(dir .. "/repo/.git", "p")
vim.fn.writefile({ "{}" }, dir .. "/repo/apps/web/package.json")
vim.fn.writefile({ "<Project/>" }, dir .. "/repo/server/Test.csproj")
vim.fn.writefile({ "lock" }, dir .. "/repo/pnpm-lock.yaml")
local project = require("core.project")
check(
	project.root(dir .. "/repo/server/Components/Pages/Index.razor") == dir .. "/repo/server",
	"Nearest csproj outranks parent git"
)
check(
	project.root(dir .. "/repo/apps/web/src/new/deeper/file.ts") == dir .. "/repo/apps/web",
	"New nested files find nearest package"
)
check(project.package_manager(dir .. "/repo/apps/web") == "pnpm", "Monorepo workspace lockfile")
vim.fn.writefile({ '{"packageManager":"bun@1.3.0"}' }, dir .. "/repo/apps/web/package.json")
check(project.package_manager(dir .. "/repo/apps/web") == "bun", "Explicit package manager wins")
check(project.package_manager("/") == "npm", "Root traversal terminates")
check(project.root(dir .. "/repo/no-marker.lua") == dir .. "/repo", "Git fallback")
vim.fn.mkdir(dir .. "/repo/python/src", "p")
vim.fn.writefile({ "setup()" }, dir .. "/repo/python/setup.py")
check(
	project.root(dir .. "/repo/python/src/a.py", { "setup.py", ".git" }) == dir .. "/repo/python",
	"Server-specific Python root"
)
vim.fn.mkdir(dir .. "/repo/native/src", "p")
vim.fn.writefile({ "[]" }, dir .. "/repo/native/compile_commands.json")
check(
	project.root(dir .. "/repo/native/src/a.cpp", { { "compile_commands.json" }, ".git" }) == dir .. "/repo/native",
	"Nested server markers preserved"
)
local buf = vim.api.nvim_create_buf(true, false)
vim.api.nvim_buf_set_name(buf, dir .. "/large.json")
vim.fn.writefile({ string.rep("x", 1024 * 1024 + 1) }, dir .. "/large.json")
check(require("config.runtime").is_large(buf), "Large file guard")
check(vim.g.colors_name == "kanagawa" and require("kanagawa")._CURRENT_THEME == "dragon", "Theme loaded")
check(vim.fn.exists(":NvimDoctor") == 2, "Doctor available")
check(vim.fn.exists(":NvimToolsInstall") == 2, "Explicit tools command")
check(require("lazy.core.config").options.install.missing == false, "No automatic plugin install")
local config = require("blink.cmp.config")
check(vim.tbl_contains(config.sources.per_filetype.razor, "emmet"), "Independent Emmet source")
check(config.sources.providers.lsp.async == true, "Slow LSP cannot block Emmet")
local hl = vim.api.nvim_get_hl(0, { name = "@tag.html", link = false })
check(hl.fg ~= nil, "HTML tag color available")
vim.fn.delete(dir, "rf")
print(("PASS: %d architecture checks"):format(checks))
