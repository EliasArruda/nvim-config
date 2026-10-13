local M = {}
local data =
	vim.json.decode(table.concat(vim.fn.readfile(vim.fn.stdpath("config") .. "/data/symbols-icons.json"), "\n"))
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
			file = { glyph = "", hl = highlight(data.default.file) },
			directory = { glyph = "", hl = highlight(data.default.directory) },
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
			opts[category][name] = { glyph = glyph, hl = highlight(id) }
		end
	end
	return opts
end

function M.preview()
	local mini = require("mini.icons")
	local samples = {
		{ "directory", "src" },
		{ "directory", "Components" },
		{ "directory", "Pages" },
		{ "directory", "Services" },
		{ "directory", "Models" },
		{ "directory", ".github" },
		{ "file", "Program.cs" },
		{ "file", "Home.razor" },
		{ "file", "Test.csproj" },
		{ "file", "appsettings.json" },
		{ "file", "App.vue" },
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
	local lines, icons = { "Symbols — adaptação para Neovim", "Referência VSCode: " .. data.version, "" }, {}
	for _, sample in ipairs(samples) do
		local glyph, hl = mini.get(sample[1], sample[2])
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
	vim.api.nvim_create_user_command(
		"SymbolsIcons",
		M.preview,
		{ force = true, desc = "Preview Symbols-inspired file and folder icons" }
	)
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = vim.api.nvim_create_augroup("config_symbols_colors", { clear = true }),
		callback = M.apply,
	})
end

return M
