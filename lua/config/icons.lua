local M = {}
local data =
	vim.json.decode(table.concat(vim.fn.readfile(vim.fn.stdpath("config") .. "/data/symbols-icons.json"), "\n"))
local font_path = (vim.env.XDG_DATA_HOME or vim.fn.expand("~/.local/share"))
	.. "/fonts/nvim-symbols/NeovimSymbols-Regular.ttf"
local metadata_path = font_path:gsub("%.ttf$", ".json")
local font_matches = false
if vim.fn.filereadable(font_path) == 1 and vim.fn.filereadable(metadata_path) == 1 then
	local ok, metadata = pcall(vim.json.decode, table.concat(vim.fn.readfile(metadata_path), "\n"))
	font_matches = ok
		and type(metadata) == "table"
		and metadata.signature == data.font_signature
		and metadata.renderer == "resvg-sbix-v1"
end
local glyphs = {
	csharp = "󰌛",
	razor = "",
	["visual-studio"] = "",
	fsharp = "",
	js = "󰌞",
	ts = "󰛦",
	["ts-types"] = "󰛦",
	dts = "󰛦",
	tsconfig = "󰛦",
	react = "",
	["react-ts"] = "",
	["react-test"] = "",
	vue = "󰡄",
	svelte = "",
	["svelte-ts"] = "",
	astro = "",
	node = "󰎙",
	npm = "󰛷",
	yarn = "",
	python = "󰌠",
	rust = "󱘗",
	ruby = "󰴭",
	go = "",
	["go-mod"] = "",
	lua = "󰢱",
	java = "󰬷",
	kotlin = "",
	dart = "",
	php = "󰌟",
	c = "",
	cplus = "",
	markdown = "󰍔",
	mdx = "󰍔",
	yaml = "",
	shell = "󰆍",
	docker = "󰡨",
	git = "",
	github = "",
	gitlab = "󰮠",
	lock = "",
	license = "󰿃",
	database = "󰆼",
	image = "",
	svg = "󰜡",
	video = "",
	audio = "",
	font = "",
	compressed = "",
	gear = "",
	document = "",
	text = "",
	["code-gray"] = "󰅴",
	elixir = "",
	graphql = "󰡷",
	terraform = "",
	swift = "󰛥",
}

local function highlight(id)
	return "SymbolsColor" .. (data.colors[id] or "#64748B"):sub(2)
end

function M.using_font()
	return (vim.g.neovide == true or vim.g.neovide == 1) and vim.g.symbols_icons_font ~= false and font_matches
end

function M.completion_icon(ctx)
	if ctx.kind == "File" or ctx.kind == "Folder" then
		return require("mini.icons").get(ctx.kind == "Folder" and "directory" or "file", ctx.item.label:gsub("/$", ""))
	end
	return ctx.kind_icon, "BlinkCmpKind" .. ctx.kind
end

function M.gui_font()
	return M.using_font() and "JetBrainsMono Nerd Font,Neovim Symbols:h16" or "JetBrainsMono Nerd Font:h16"
end

function M.icon(id, fallback)
	local entry = data.catalog and data.catalog[id]
	if M.using_font() and entry then
		return vim.fn.nr2char(entry.codepoint), highlight(id)
	end
	return glyphs[id] or fallback or "", highlight(id)
end

function M.apply()
	for _, color in pairs(data.colors) do
		vim.api.nvim_set_hl(0, "SymbolsColor" .. color:sub(2), { fg = color })
	end
end

function M.options()
	local mini = require("mini.icons")
	local opts = {
		style = "glyph",
		default = {
			file = { glyph = M.icon(data.default.file, ""), hl = highlight(data.default.file) },
			directory = { glyph = M.icon(data.default.directory, ""), hl = highlight(data.default.directory) },
		},
	}
	for _, category in ipairs({ "extension", "file", "filetype", "directory" }) do
		opts[category] = {}
		for name, id in pairs(data[category]) do
			local glyph = glyphs[id]
			if category == "directory" then
				glyph = ""
			elseif id:match("^brackets%-") then
				glyph = "󰅴"
			elseif id:match("^code%-") then
				glyph = "󰅴"
			end
			if not glyph then
				glyph = mini.get(category, name)
			end
			glyph = M.icon(id, glyph)
			-- MiniIcons normalizes extension lookups, including compound names.
			local key = (category == "extension" or category == "filetype") and name:lower() or name
			opts[category][key] = { glyph = glyph, hl = highlight(id) }
		end
	end
	return opts
end

function M.explorer_format(item, picker)
	local chunks = Snacks.picker.format.file(item, picker)
	if not item.dir or picker.opts.icons.files.enabled == false then
		return chunks
	end
	-- Snacks normally replaces every open folder with one generic glyph. Keep
	-- the original Symbols drawing, including its badge, for expanded folders.
	local path = Snacks.picker.util.path(item) or item.file
	local old_glyph, old_hl = require("mini.icons").get("directory", path)
	local glyph, hl = old_glyph, old_hl
	if not item.parent then
		glyph, hl = M.icon(data.default.root or data.default.directory, "")
	elseif not M.using_font() then
		return chunks
	end
	local expected = item.open and picker.opts.icons.files.dir_open or old_glyph
	for _, chunk in ipairs(chunks) do
		if chunk.virtual and chunk[2] == old_hl and vim.startswith(chunk[1] or "", expected) then
			chunk[1] = Snacks.picker.util.align(glyph, picker.opts.formatters.file.icon_width or 2)
			chunk[2] = hl
			break
		end
	end
	return chunks
end

function M.preview(category)
	local mini = require("mini.icons")
	local samples = {
		{ "directory", "src" },
		{ "directory", "Components" },
		{ "directory", "Pages" },
		{ "directory", "Services" },
		{ "directory", "Models" },
		{ "directory", ".github" },
		{ "directory", "assets" },
		{ "directory", "fonts" },
		{ "directory", "database" },
		{ "directory", "node_modules" },
		{ "directory", ".vscode" },
		{ "file", "Program.cs" },
		{ "file", "Home.razor" },
		{ "file", "Test.csproj" },
		{ "file", "appsettings.json" },
		{ "file", "App.vue" },
		{ "file", "App.svelte" },
		{ "file", "index.astro" },
		{ "file", "vite.config.ts" },
		{ "file", "App.tsx" },
		{ "file", "main.ts" },
		{ "file", "index.js" },
		{ "file", "package.json" },
		{ "file", "main.go" },
		{ "file", "main.py" },
		{ "file", "main.rs" },
		{ "file", "Dockerfile" },
		{ "file", "README.md" },
	}
	if category and category ~= "" then
		samples = {}
		if category == "all" then
			for _, id in ipairs(vim.tbl_keys(data.catalog)) do
				samples[#samples + 1] = { "catalog", id }
			end
		else
			for name in pairs(data[category]) do
				samples[#samples + 1] = { category, name }
			end
		end
		table.sort(samples, function(a, b)
			return a[2] < b[2]
		end)
	end
	local mode = M.using_font() and "SVGs da Symbols / fonte auxiliar" or "Nerd Font / compatibilidade"
	local lines, icons = { "Symbols — catálogo de ícones", "VSCode: " .. data.version .. " | " .. mode, "" }, {}
	for _, sample in ipairs(samples) do
		local glyph, hl
		if sample[1] == "catalog" then
			glyph, hl = M.icon(sample[2])
		else
			glyph, hl = mini.get(sample[1], sample[2])
		end
		lines[#lines + 1] = "  " .. glyph .. "  " .. sample[2]
		icons[#icons + 1] = { row = #lines - 1, length = #glyph, hl = hl }
	end
	vim.cmd("new")
	vim.bo.buftype, vim.bo.bufhidden, vim.bo.swapfile = "nofile", "wipe", false
	vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
	local namespace = vim.api.nvim_create_namespace("config.symbols.preview")
	for _, icon in ipairs(icons) do
		vim.api.nvim_buf_set_extmark(0, namespace, icon.row, 2, { end_col = 2 + icon.length, hl_group = icon.hl })
	end
	vim.bo.modifiable = false
end

function M.setup()
	M.apply()
	vim.api.nvim_create_user_command("SymbolsIcons", function(args)
		local category = args.args
		if
			category ~= "" and not vim.tbl_contains({ "all", "file", "directory", "extension", "filetype" }, category)
		then
			error("Use :SymbolsIcons [all|file|directory|extension|filetype]")
		end
		M.preview(category)
	end, {
		force = true,
		nargs = "?",
		complete = function()
			return { "all", "file", "directory", "extension", "filetype" }
		end,
		desc = "Preview the complete Symbols icon catalog",
	})
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = vim.api.nvim_create_augroup("config_symbols_colors", { clear = true }),
		callback = M.apply,
	})
end

return M
