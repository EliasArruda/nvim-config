vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- ─────────────────────────────────────────────
-- ⚙️ GLOBAL FLAGS (plugins / features)
-- ─────────────────────────────────────────────
vim.g.autoformat = true
vim.g.snacks_animate = true

-- plugin behavior switches (safe standalone usage)
vim.g.lazyvim_picker = "auto"
vim.g.lazyvim_cmp = "auto"
vim.g.ai_cmp = true
vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }
vim.g.root_lsp_ignore = { "copilot" }
vim.g.deprecation_warnings = false
vim.g.trouble_lualine = true

-- ─────────────────────────────────────────────
-- ✏️ EDITOR CORE BEHAVIOR
-- ─────────────────────────────────────────────
local opt = vim.opt

opt.autowrite = true

-- clipboard integration (disabled over SSH for safety)
opt.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus"
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 2
opt.confirm = true
opt.cursorline = true

-- ─────────────────────────────────────────────
-- 🧾 INDENTATION SETTINGS
-- ─────────────────────────────────────────────
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.shiftround = true

-- ─────────────────────────────────────────────
-- 🔍 SEARCH BEHAVIOR
-- ─────────────────────────────────────────────
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "nosplit"
opt.grepprg = "rg --vimgrep"
opt.grepformat = "%f:%l:%c:%m"

-- ─────────────────────────────────────────────
-- 🧭 UI / VISUALS
-- ─────────────────────────────────────────────
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.termguicolors = true
opt.cursorline = true
opt.laststatus = 3
opt.showmode = false
opt.ruler = false

