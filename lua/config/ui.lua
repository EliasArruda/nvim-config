local M = {}
function M.apply()
	if vim.g.colors_name ~= "nightfly" then
		return
	end
	local p = require("nightfly").palette
	local c = {
		blue = p.blue,
		cyan = p.turquoise,
		fg_dark = p.cadet_blue,
		fg = p.white,
		bg_float = "#0a0c10",
		border_highlight = "#343b44",
		magenta = p.violet,
		purple = p.purple,
		red = p.red,
		orange = p.orange,
		yellow = p.yellow,
		green = p.green,
		teal = p.emerald,
		comment = p.grey_blue,
	}
	-- Neutralize UI surfaces while retaining Nightfly syntax foregrounds.
	local backgrounds = {
		[p.bg] = "#080c10",
		[p.black_blue] = "#0a0c10",
		[p.dark_blue] = "#0d1014",
		[p.ink_blue] = "#0a0c10",
		[p.deep_blue] = "#101419",
		[p.storm_blue] = "#0d1014",
		[p.stone_blue] = "#14191f",
		[p.slate_blue] = "#1b2129",
		[p.regal_blue] = "#151b22",
		[p.pickle_blue] = "#1b2129",
		[p.carbon_blue] = "#1b2129",
		[p.cyan_blue] = "#1b2129",
		[p.bay_blue] = "#151b22",
	}
	for name, hl in pairs(vim.api.nvim_get_hl(0, {})) do
		if hl.bg then
			local replacement = backgrounds[("#%06x"):format(hl.bg)]
			if replacement then
				hl.bg = tonumber(replacement:sub(2), 16)
				vim.api.nvim_set_hl(0, name, hl)
			end
		end
	end
	vim.g.terminal_color_0 = "#080c10"
	local groups = {
		Normal = { fg = c.fg, bg = "#080c10" },
		NormalNC = { fg = c.fg, bg = "#080c10" },
		NormalSB = { fg = c.fg, bg = "#0a0c10" },
		NormalFloat = { fg = c.fg, bg = c.bg_float },
		FloatBorder = { fg = c.border_highlight, bg = c.bg_float },
		WinSeparator = { fg = "#252b32", bg = "#080c10" },
		CursorLine = { bg = "#0d1014" },
		CursorLineNr = { fg = c.blue, bold = true },
		Visual = { bg = "#151b22" },
		Pmenu = { fg = c.fg, bg = c.bg_float },
		PmenuSel = { fg = p.white_blue, bg = "#151b22", bold = true },
		PmenuSbar = { bg = "#0d1014" },
		PmenuThumb = { bg = "#343b44" },
		TabLineFill = { bg = "#080c10" },
		TabLine = { fg = "#8894a5", bg = "#0a0c10" },
		TabLineSel = { fg = c.fg, bg = "#101419", bold = true },
		BufferLineFill = { bg = "#080c10" },
		BufferLineBackground = { fg = "#8894a5", bg = "#0a0c10" },
		BufferLineBufferSelected = { fg = c.fg, bg = "#101419", bold = true },
		BufferLineIndicatorSelected = { fg = c.blue, bg = "#101419" },
		SnacksIndent = { fg = "#26313f" },
		SnacksIndentScope = { fg = "#3c4654" },
		TelescopeSelection = { fg = p.white_blue, bg = "#151b22", bold = true },
		TelescopeSelectionCaret = { fg = c.blue, bg = "#151b22" },
		TelescopePromptTitle = { fg = c.blue, bg = "#0d1014", bold = true },
		TelescopeResultsTitle = { fg = c.fg, bg = c.bg_float },
		TelescopePreviewTitle = { fg = c.fg, bg = "#0a0c10" },
		TelescopeResultsNormal = { fg = c.fg, bg = c.bg_float },
		TelescopeResultsBorder = { fg = c.border_highlight, bg = c.bg_float },
		TelescopePreviewNormal = { fg = c.fg, bg = "#0a0c10" },
		TelescopePreviewBorder = { fg = "#252b32", bg = "#0a0c10" },
		BlinkCmpMenuSelection = { fg = p.white_blue, bg = "#151b22", bold = true },
		BlinkCmpDoc = { fg = c.fg, bg = "#0a0c10" },
		BlinkCmpDocBorder = { fg = c.border_highlight, bg = "#0a0c10" },
		["@tag.html"] = { link = "@tag" },
		["@tag.razor"] = { link = "@tag" },
		["@tag.attribute.html"] = { link = "@tag.attribute" },
		["@tag.delimiter.html"] = { fg = c.fg_dark },
		["@lsp.type.class.razor"] = { fg = c.cyan },
		SnacksDashboardHeader = { fg = c.blue, bold = true },
		NoiceTransparent = { fg = c.fg, bg = c.bg_float },
		NoiceBorder = { fg = c.border_highlight, bg = c.bg_float },
		NoiceCmdlinePopupTitle = { fg = c.blue, bg = c.bg_float },
		NoiceCmdlineIcon = { fg = c.blue },
		TelescopeBorder = { fg = c.border_highlight, bg = c.bg_float },
		TelescopePromptBorder = { fg = c.blue, bg = "#0d1014" },
		TelescopePromptNormal = { fg = c.fg, bg = "#0d1014" },
		TelescopeNormal = { fg = c.fg, bg = c.bg_float },
		BlinkCmpMenu = { fg = c.fg, bg = c.bg_float },
		BlinkCmpMenuBorder = { fg = c.border_highlight, bg = c.bg_float },
		OutlineSky = { fg = c.blue },
		OutlineBlue = { fg = c.blue },
		OutlineIndigo = { fg = c.magenta },
		OutlinePurple = { fg = c.purple },
		OutlinePink = { fg = c.magenta },
		OutlineRed = { fg = c.red },
		OutlineOrange = { fg = c.orange },
		OutlineAmber = { fg = c.yellow },
		OutlineGreen = { fg = c.green },
		OutlineTeal = { fg = c.teal },
		OutlineGray = { fg = c.comment },
		OutlineSlate = { fg = c.fg_dark },
	}
	for name, value in pairs(groups) do
		vim.api.nvim_set_hl(0, name, value)
	end
	for index, color in ipairs({ c.blue, c.cyan, c.green, c.yellow, c.magenta, c.orange }) do
		vim.api.nvim_set_hl(0, "RenderMarkdownH" .. index, { fg = color, bold = true })
	end
end
function M.setup()
	M.apply()
	vim.api.nvim_create_autocmd(
		"ColorScheme",
		{ group = vim.api.nvim_create_augroup("config_visual_system", { clear = true }), callback = M.apply }
	)
end
return M
