local M = {}
function M.apply()
	if vim.g.colors_name ~= "nightfly" then return end
	local p = require("nightfly").palette
	local c = {
		blue = p.blue, cyan = p.turquoise, fg_dark = p.cadet_blue,
		fg = p.white, bg_float = "#10151b", border_highlight = "#46515e",
		magenta = p.violet, purple = p.purple, red = p.red,
		orange = p.orange, yellow = p.yellow, green = p.green,
		teal = p.emerald, comment = p.grey_blue,
	}
	-- Neutralize UI surfaces while retaining Nightfly syntax foregrounds.
	local backgrounds = {
		[p.bg] = "#080c10", [p.black_blue] = "#0d1117",
		[p.dark_blue] = "#11171e", [p.ink_blue] = "#10151b",
		[p.deep_blue] = "#161c24", [p.storm_blue] = "#1c232d",
		[p.stone_blue] = "#202832", [p.slate_blue] = "#28313d",
	}
	for name, hl in pairs(vim.api.nvim_get_hl(0, {})) do
		if hl.bg then
			local replacement = backgrounds[("#%06x"):format(hl.bg)]
			if replacement then hl.bg = tonumber(replacement:sub(2), 16); vim.api.nvim_set_hl(0, name, hl) end
		end
	end
	vim.g.terminal_color_0 = "#080c10"
	local groups = {
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
		TelescopePromptBorder = { fg = c.blue, bg = c.bg_float },
		TelescopePromptNormal = { fg = c.fg, bg = c.bg_float },
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
