local count = 0
local function check(value, message)
	assert(value, message)
	count = count + 1
end
vim.api.nvim_exec_autocmds("User", { pattern = "VeryLazy" })
require("lazy").load({ plugins = { "nvim-lspconfig", "conform.nvim", "nvim-treesitter-textobjects" } })
for _, file in ipairs(vim.fn.globpath(vim.fn.stdpath("config"), "lua/**/*.lua", false, true)) do
	local chunk, err = loadfile(file)
	check(chunk, err or file)
end
for _, key in ipairs({ "<leader>us", "<leader>uT", "<leader>uf", "]f", "[c" }) do
	check(not vim.tbl_isempty(vim.fn.maparg(key, "n", false, true)), "Missing map: " .. key)
end
check(vim.fn.maparg("<leader>rt", "n", false, true).desc == "Ruby: test nearest", "Ruby mapping")
check(vim.fn.maparg("<leader>rpt", "n", false, true).desc == "Project: test", "Web mapping")
check(
	vim.lsp.config.vue_ls.capabilities.textDocument.colorProvider.dynamicRegistration == false,
	"Vue capabilities overwritten"
)
check(require("lazy.core.config").plugins["telescope.nvim"].version == false, "Telescope version overridden")
local warnings = {}
local utils = require("blink.cmp.lib.utils")
local notify = utils.notify
utils.notify = function(value)
	warnings[#warnings + 1] = value
end
local config = require("blink.cmp.config")
require("blink.cmp.config.completion").validate(config.completion)
require("blink.cmp.config.sources").validate(config.sources)
utils.notify = notify
check(#warnings == 0, "Blink config has unexpected fields")
local temp = vim.fn.tempname()
vim.fn.mkdir(temp, "p")
vim.cmd.cd(temp)
-- Missing package.json must report a useful message instead of throwing.
local old_notify = vim.notify
vim.notify = function() end
check(pcall(require("plugins.lang.web-dev")[2].keys[1][2]), "Web action throws outside project")
vim.notify = old_notify
-- Ensure all required language/query combinations compile against installed parsers.
for _, lang in ipairs({ "c_sharp", "razor", "html", "css", "javascript" }) do
	local loaded, available = pcall(vim.treesitter.language.add, lang)
	check(loaded and available, "Parser: " .. lang)
	for _, kind in ipairs({ "highlights", "injections", "folds", "locals", "textobjects" }) do
		local ok, err = pcall(vim.treesitter.query.get, lang, kind)
		check(ok, lang .. "/" .. kind .. ": " .. tostring(err))
	end
end
-- Venn must restore a buffer-local hover mapping, including Lua callbacks.
local callback = function() end
vim.keymap.set("n", "K", callback, { buffer = 0, desc = "Original hover" })
_G.Toggle_venn()
_G.Toggle_venn()
check(vim.fn.maparg("K", "n", false, true).desc == "Original hover", "Venn lost LSP hover")
-- Saving honors changes to global and buffer-local autoformat flags.
local conform = require("conform")
local called = 0
local format = conform.format
conform.format = function()
	called = called + 1
end
vim.api.nvim_buf_set_name(0, temp .. "/format.lua")
vim.g.autoformat = false
vim.api.nvim_exec_autocmds("BufWritePre", { buffer = 0 })
check(called == 0, "Autoformat global disable ignored")
vim.g.autoformat = true
vim.b.autoformat = false
vim.api.nvim_exec_autocmds("BufWritePre", { buffer = 0 })
check(called == 0, "Autoformat buffer disable ignored")
vim.b.autoformat = nil
vim.api.nvim_exec_autocmds("BufWritePre", { buffer = 0 })
check(called == 1, "Autoformat not restored")
conform.format = format
-- SARIF output keeps every finding and resolves filenames against the process cwd.
local items = require("configs.langs.go-tools").sarif_items({
	runs = {
		{
			results = {
				{
					ruleId = "TEST",
					message = { text = "first" },
					locations = {
						{ physicalLocation = { artifactLocation = { uri = "a.go" }, region = { startLine = 5 } } },
					},
				},
				{ ruleId = "NO_LOCATION", message = { text = "second" } },
			},
		},
	},
}, temp)
check(#items == 2 and items[1].filename == temp .. "/a.go" and items[1].lnum == 5, "SARIF results lost")
-- Templates must never move the cursor or modify a different buffer.
vim.cmd("enew!")
local other = vim.api.nvim_get_current_buf()
vim.api.nvim_buf_set_lines(other, 0, -1, false, { "sentinel" })
vim.cmd.edit(temp .. "/Fresh.vue")
vim.api.nvim_set_current_buf(other)
vim.wait(250)
check(vim.api.nvim_buf_get_lines(other, 0, -1, false)[1] == "sentinel", "Template changed another buffer")
-- HTML injections must recover after incomplete Razor tags/quotes are edited.
-- Whole-file parsing alone misses the unsorted combined-range regression.
local razor_buf = vim.api.nvim_create_buf(false, true)
vim.api.nvim_buf_set_lines(razor_buf, 0, -1, false, {
	'@page "/audit"',
	"<h1>Title</h1>",
	'<div class="box">',
	"",
	"<p>Stable</p>",
	"</div>",
	"@code { private int number = 1; }",
})
local razor_parser = vim.treesitter.get_parser(razor_buf, "razor")
razor_parser:parse(true)
for _ = 1, 3 do
	for _, text in ipairs({ "<", "<div", '<div class="', '<div class="x">', '<div class="x"></div>' }) do
		vim.api.nvim_buf_set_lines(razor_buf, 3, 4, false, { text })
		razor_parser:parse(true)
	end
	local tags, csharp = {}, false
	razor_parser:for_each_tree(function(tree, language)
		local query = vim.treesitter.query.get(language:lang(), "highlights")
		if not query then
			return
		end
		for id, node in query:iter_captures(tree:root(), razor_buf, 0, -1) do
			local text = vim.treesitter.get_node_text(node, razor_buf)
			if language:lang() == "html" and query.captures[id] == "tag" then
				tags[#tags + 1] = text
			end
			if language:lang() == "razor" and text == "private" then
				csharp = true
			end
		end
	end)
	check(#tags == 8 and vim.tbl_contains(tags, "p"), "Razor HTML colors did not recover after editing")
	check(csharp, "Razor C# highlighting lost")
end
vim.api.nvim_buf_delete(razor_buf, { force = true })
local blocked = require("blink.cmp.config").completion.trigger.show_on_blocked_trigger_characters
vim.bo.filetype = "razor"
vim.api.nvim_buf_set_lines(0, 0, -1, false, { "<div  " })
vim.api.nvim_win_set_cursor(0, { 1, 5 })
check(not vim.tbl_contains(blocked(), " "), "Razor HTML attribute completion blocked")
vim.api.nvim_buf_set_lines(0, 0, -1, false, { "@code { var value = 1; }" })
vim.api.nvim_win_set_cursor(0, { 1, 18 })
check(vim.tbl_contains(blocked(), " "), "Razor HTML exception leaked into C#")
print(("PASS: %d regression checks"):format(count))
