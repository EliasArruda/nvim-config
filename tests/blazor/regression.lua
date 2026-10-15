local checks = 0
local function check(value, message)
	assert(value, message)
	checks = checks + 1
end
require("lazy").load({ plugins = { "blink.cmp", "nvim-treesitter" } })
local razor = require("configs.langs.razor")
local original_buf = vim.api.nvim_get_current_buf()
local malformed = vim.api.nvim_create_buf(false, true)
vim.api.nvim_set_current_buf(malformed)
local unfinished_code = "@code { void F() { var x = a <b "
vim.api.nvim_buf_set_lines(malformed, 0, -1, false, { unfinished_code })
vim.bo.filetype = "razor"
vim.api.nvim_win_set_cursor(0, { 1, #unfinished_code })
check(not razor.in_tag(), "Fresh malformed C# parse is not HTML")
vim.api.nvim_set_current_buf(original_buf)
vim.api.nvim_buf_delete(malformed, { force = true })
vim.bo.filetype = "razor"
local function context(lines, row, col)
	vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
	vim.api.nvim_win_set_cursor(0, { row, col })
	local parser = vim.treesitter.get_parser(0, "razor")
	parser:parse(true)
	return razor.in_tag()
end
check(context({ "<InputText", "  " }, 2, 2), "Multiline attribute context")
check(context({ '<InputText TValue="List<string>"', "  " }, 2, 2), "Generic component parameter")
check(not context({ '<div class="a ' }, 1, 14), "Do not replace C# or value completion")
check(not context({ "<!-- <div " }, 1, 10), "HTML comment is not a tag")
check(not context({ "@* <div " }, 1, 8), "Razor comment is not a tag")
check(not context({ '@code { var text = "<div "; }' }, 1, 25), "C# string is not HTML")
check(not context({ "@code { List<Person> people = new(); }" }, 1, 19), "C# generic is not HTML")
check(not context({ "<div>text " }, 1, 10), "Text after closed tag is not an attribute")
check(not context({ "@code { void F() { var x = a <b " }, 1, 30), "Unfinished C# block is not markup")
local config = require("blink.cmp.config")
context({ "<InputText", "  " }, 2, 2)
check(
	not vim.tbl_contains(config.completion.trigger.show_on_blocked_trigger_characters(), " "),
	"Blink multiline trigger"
)
check(not config.completion.list.selection.preselect({ bufnr = 0 }), "No implicit Razor selection")
check(not config.completion.list.selection.auto_insert({ bufnr = 0 }), "Do not mutate Razor when browsing completion")
local provider = config.sources.providers.lsp.override.get_completions
local received
local fake = {
	get_completions = function(_, ctx)
		received = ctx
	end,
}
local input = { bufnr = 0, cursor = { 2, 2 }, trigger = { character = " ", kind = "trigger_character" } }
provider(fake, input, function() end)
check(received.trigger.kind == "manual" and received.trigger.character == nil, "HTML attributes request Invoked")
check(input.trigger.character == " ", "Provider must preserve original context")
context({ "@code { int value = 1; }" }, 1, 19)
provider(
	fake,
	{ bufnr = 0, cursor = { 1, 19 }, trigger = { character = " ", kind = "trigger_character" } },
	function() end
)
check(received.trigger.character == " ", "C# trigger must not become HTML request")
local lines = {
	'<div class="box">',
	'<InputText @bind-Value="',
	"<p>Stable</p>",
	"</div>",
	'@code { private string name = ""; }',
}
context(lines, 2, 23)
local parser = vim.treesitter.get_parser(0, "razor")
local function tags()
	parser:parse(true)
	local found = {}
	parser:for_each_tree(function(tree, language)
		local query = vim.treesitter.query.get(language:lang(), "highlights")
		if query then
			for id, node in query:iter_captures(tree:root(), 0, 0, -1) do
				if query.captures[id] == "tag" then
					found[#found + 1] = vim.treesitter.get_node_text(node, 0)
				end
			end
		end
	end)
	return found
end
check(
	vim.tbl_contains(tags(), "div") and vim.tbl_contains(tags(), "InputText"),
	"Markup keeps colors while quote is incomplete"
)
for _ = 1, 5 do
	vim.api.nvim_buf_set_lines(0, 1, 2, false, { '<InputText @bind-Value="name" />' })
	check(vim.tbl_contains(tags(), "p"), "Stable tag recovers after closing attribute")
	vim.api.nvim_buf_set_lines(0, 1, 2, false, { '<InputText @bind-Value="' })
	check(vim.tbl_contains(tags(), "div"), "Repeated edits retain outer tag")
end
vim.api.nvim_buf_set_lines(0, 0, -1, false, { "@code { void Broken() { List< } }" })
parser:parse(true)
check(#tags() == 0, "Errors inside C# must not become HTML")
-- Preserve combined SQL/JSON/XML injections inherited from C#.
local inherited_combining = false
for _, file in ipairs(vim.treesitter.query.get_files("razor", "injections")) do
	if not vim.fs.normalize(file):find("/razor/", 1, true) then
		inherited_combining = inherited_combining
			or table.concat(vim.fn.readfile(file), "\n"):find("injection.combined", 1, true) ~= nil
	end
end
if inherited_combining then
	local retained = false
	for _, pattern in pairs(vim.treesitter.query.get("razor", "injections").info.patterns) do
		for _, directive in ipairs(pattern) do
			retained = retained or (directive[1] == "set!" and directive[2] == "injection.combined")
		end
	end
	check(retained, "Inherited C# combining must remain intact")
end
context({ "div.container" }, 1, 13)
check(not razor.is_code_or_comment(), "Emmet abbreviation is not a recovered C# expression")
context({ "@person.Name" }, 1, 12)
check(razor.is_code_or_comment(), "Real Razor expressions remain C#")
context({ "@if (person.Name" }, 1, 16)
check(razor.is_code_or_comment(), "Incomplete if condition remains C#")
context({ "@foreach (var item in items" }, 1, 26)
check(razor.is_code_or_comment(), "Incomplete foreach header remains C#")
context({ '@if (person.Name == ")" && check' }, 1, 31)
check(razor.is_code_or_comment(), "Quoted parenthesis does not finish a C# header")
local condition = "@if (person.Name) { <span></span> }"
context({ condition }, 1, condition:find("Name", 1, true) + 3)
check(razor.is_code_or_comment(), "If condition remains C#")
context({ condition }, 1, condition:find("<span>", 1, true) + 4)
check(not razor.is_code_or_comment(), "If body markup allows Emmet")
local foreach = "@foreach (var item in items) { <span></span> }"
context({ foreach }, 1, foreach:find("items", 1, true) + 4)
check(razor.is_code_or_comment(), "Foreach header remains C#")
context({ foreach }, 1, foreach:find("<span>", 1, true) + 4)
check(not razor.is_code_or_comment(), "Foreach body markup allows Emmet")
context({ "span" }, 1, 4)
local transform = config.sources.providers.lsp.transform_items
local suggestions = transform({ bufnr = 0, cursor = { 1, 4 } }, {
	{ label = "span", client_name = "emmet_language_server" },
	{ label = "Span", client_name = "easy_dotnet" },
})
check(#suggestions == 1 and suggestions[1].client_name == "easy_dotnet", "Dedicated Emmet source prevents duplicate LSP entries")
context({ "@code { var text = string.Empty; }" }, 1, 25)
suggestions = transform({ bufnr = 0, cursor = { 1, 25 } }, {
	{ label = "string.Empty", client_name = "emmet_language_server" },
	{ label = "Empty", client_name = "easy_dotnet" },
})
check(#suggestions == 1 and suggestions[1].client_name == "easy_dotnet", "Keep C# completion free of Emmet markup")
vim.bo.filetype = "lua"
check(config.completion.list.selection.preselect({ bufnr = 0 }), "Other languages preserve selection")
print(("PASS: %d Blazor regression checks"):format(checks))
