-- Dashboard
vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { fg = "#800000", bold = true })

-- BACKGROUNDS (≈ 50% mais escuros baseados nos foregrounds)
vim.api.nvim_set_hl(0, "RenderMarkdownH1Bg", { bg = "#803C35" })
vim.api.nvim_set_hl(0, "RenderMarkdownH2Bg", { bg = "#80663D" })
vim.api.nvim_set_hl(0, "RenderMarkdownH3Bg", { bg = "#366F4D" })
vim.api.nvim_set_hl(0, "RenderMarkdownH4Bg", { bg = "#365C71" })
vim.api.nvim_set_hl(0, "RenderMarkdownH5Bg", { bg = "#544680" })
vim.api.nvim_set_hl(0, "RenderMarkdownH6Bg", { bg = "#803660" })

-- HEADINGS (texto mais forte / legível)
vim.api.nvim_set_hl(0, "@markup.heading.1.markdown", { fg = "#FF6B4A", bold = true }) -- vermelho mais vivo
vim.api.nvim_set_hl(0, "@markup.heading.2.markdown", { fg = "#FFE082", bold = true }) -- amarelo mais claro
vim.api.nvim_set_hl(0, "@markup.heading.3.markdown", { fg = "#4DFF9A", bold = true }) -- verde mais vibrante
vim.api.nvim_set_hl(0, "@markup.heading.4.markdown", { fg = "#5FDFFF", bold = true }) -- ciano mais forte
vim.api.nvim_set_hl(0, "@markup.heading.5.markdown", { fg = "#B699FF", bold = true }) -- roxo mais claro
vim.api.nvim_set_hl(0, "@markup.heading.6.markdown", { fg = "#FF5FC0", bold = true }) -- rosa mais vivo

-- FOREGROUNDS (mantidos - sua base perfeita)
vim.api.nvim_set_hl(0, "RenderMarkdownH1", { fg = "#FF8A6B", bold = true })
vim.api.nvim_set_hl(0, "RenderMarkdownH2", { fg = "#FFD27A", bold = true })
vim.api.nvim_set_hl(0, "RenderMarkdownH3", { fg = "#6BE39B", bold = true })
vim.api.nvim_set_hl(0, "RenderMarkdownH4", { fg = "#6BB7E3", bold = true })
vim.api.nvim_set_hl(0, "RenderMarkdownH5", { fg = "#A98BFF", bold = true })
vim.api.nvim_set_hl(0, "RenderMarkdownH6", { fg = "#FF6BC1", bold = true })

-- Dash
vim.api.nvim_set_hl(0, "RenderMarkdownDash", {
	fg = "#8BE9FD",
	bold = true,
})
--------------------------------------

vim.api.nvim_set_hl(0, "MiniIconsPurple", { fg = "#BF40BF" }) -- Roxo
vim.api.nvim_set_hl(0, "MiniIconsMarine", { fg = "#3178C6" }) -- Roxo
vim.api.nvim_set_hl(0, "SnacksPickerDir", { link = "Text" })
vim.api.nvim_set_hl(0, "SnacksPickerPathHidden", { link = "Text" })
vim.api.nvim_set_hl(0, "SnacksPickerGitStatusUntracked", { link = "Special" })

-- Highlights obsidian
vim.api.nvim_set_hl(0, "@markup.strong.markdown_inline", {
	fg = "#4f9cff",
	bold = true,
})

vim.api.nvim_set_hl(0, "@markup.italic.markdown_inline", {
	fg = "#c084fc",
	bold = true,
})
