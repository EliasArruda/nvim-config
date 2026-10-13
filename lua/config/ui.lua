local M = {}
function M.apply()
	local ok, colors = pcall(require, "kanagawa.colors")
	if not ok then return end
	local palette = colors.setup({ theme = "dragon" })
	local t = palette.theme
	local c = {
		blue = t.syn.fun, cyan = t.syn.type, fg_dark = t.ui.fg_dim,
		fg = t.ui.fg, bg_float = t.ui.float.bg, border_highlight = t.ui.float.fg_border,
		magenta = t.syn.keyword, purple = t.syn.keyword, red = t.diag.error,
		orange = t.syn.constant, yellow = t.syn.identifier, green = t.syn.string,
		teal = t.syn.special1, comment = t.syn.comment,
	}
	local groups = {
		["@tag.html"] = { fg = c.blue },
		["@tag.razor"] = { fg = c.blue },
		["@tag.attribute.html"] = { fg = c.cyan },
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
