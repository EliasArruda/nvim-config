local failures, warnings, loaded = {}, {}, 0
local notify = vim.notify
local function capture(message, level)
	if level and level >= vim.log.levels.ERROR then
		failures[#failures + 1] = tostring(message)
	elseif level and level >= vim.log.levels.WARN then
		warnings[#warnings + 1] = tostring(message)
	end
end
local ok, err = xpcall(function()
	local plugins = require("lazy.core.config").plugins
	local names = {}
	for name, plugin in pairs(plugins) do
		if plugin._.cond ~= false then
			names[#names + 1] = name
		end
	end
	table.sort(names)
	for _, name in ipairs(names) do
		vim.notify = capture
		require("lazy").load({ plugins = { name } })
		loaded = loaded + 1
	end
	vim.notify = capture
	vim.api.nvim_exec_autocmds("User", { pattern = "VeryLazy" })
	vim.wait(500)
	for name, plugin in pairs(plugins) do
		if plugin._.cond ~= false then
			for _, key in pairs(plugin.keys or {}) do
				if type(key) == "table" and type(key[2]) == "string" then
					local command = key[2]:match("^<[cC][mM][dD]>([%u][%w]*)")
					assert(not command or vim.fn.exists(":" .. command) == 2, name .. ": missing " .. tostring(command))
				end
			end
		end
	end
	assert(#failures == 0, table.concat(failures, "\n"))
	assert(#warnings == 0, table.concat(warnings, "\n"))
end, debug.traceback)
vim.notify = notify
assert(ok, err)
io.stdout:write(("PASS: %d plugins load without errors/warnings; mapped Ex commands exist"):format(loaded))

-- Noice can be unavailable in a GUI: notification shortcuts must still work.
local config = package.loaded["noice.config"]
package.loaded["noice.config"] = nil
assert(pcall(require("config.notifications").history), "Native message history failed")
assert(pcall(require("config.notifications").dismiss), "Native message dismissal failed")
package.loaded["noice.config"] = config
io.stdout:write("PASS: native notification shortcuts when Noice is unavailable")
local report = table.concat(require("config.health").report(), "\n")
assert(
	report:find("Python provider:", 1, true) and report:find("Logs (", 1, true),
	"Doctor hides environment/log information"
)
for name in pairs(require("configs.langs.lsp")) do
	local command = vim.lsp.config[name].cmd
	if type(command) == "table" then
		assert(vim.fn.executable(command[1]) == 1, name .. " executable missing: " .. tostring(command[1]))
	end
end
assert(vim.fn.executable("govulncheck") == 1, "Go security shortcut requires govulncheck")
io.stdout:write("PASS: configured language-server executables and Go vulnerability tool exist")

local directory = vim.fn.tempname()
vim.fn.mkdir(directory, "p")
vim.cmd.edit(directory .. "/note.md")
require("pastify").setup({ opts = { save = "local_file", local_path = "/assets/imgs/", filename = "audit-image" } })
vim.cmd("python3 image.config['opts']['save'] = 'local_file'")
vim.cmd("python3 pastify.main.ImageGrab.grabclipboard = lambda: pastify.main.ImageGrab.Image.new('RGB', (2, 2))")
vim.cmd.PastifyAfter()
assert(vim.fn.filereadable(directory .. "/assets/imgs/audit-image.png") == 1, "Clipboard image not saved locally")
assert(vim.api.nvim_get_current_line():find("audit%-image%.png"), "Image link not inserted")
-- Never access the user's clipboard during verification.
vim.g.clipboard = {
	name = "test clipboard",
	copy = { ["+"] = function() end, ["*"] = function() end },
	paste = {
		["+"] = function()
			return { { "controlled clipboard" }, "v" }
		end,
		["*"] = function()
			return { { "controlled clipboard" }, "v" }
		end,
	},
}
vim.cmd("unlet! g:loaded_clipboard_provider")
vim.cmd("runtime autoload/provider/clipboard.vim")
vim.cmd("python3 pastify.main.ImageGrab.grabclipboard = lambda: None")
vim.cmd.PastifyAfter()
assert(vim.api.nvim_get_current_line():find("controlled clipboard", 1, true), "Clipboard text not inserted")
vim.cmd("enew!")
vim.fn.delete(directory, "rf")
io.stdout:write("PASS: isolated Python provider and local image/text clipboard paste")
