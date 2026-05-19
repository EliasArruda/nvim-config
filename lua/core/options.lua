vim.g.mapleader = " "
-- Remove conflicting/unused global flags
-- vim.g.maplocalleader = " " -- Conflicts with space as leader
-- vim.g.lazyvim_picker = "auto"  -- Not using LazyVim
-- vim.g.lazyvim_cmp = "auto"     -- Not using LazyVim
-- vim.g.ai_cmp = true            -- No AI plugin configured
-- vim.g.deprecation_warnings = false -- Keep warnings enabled for debugging

-- ─────────────────────────────────────────────
-- ⚙️ GLOBAL FLAGS (plugins / features)
-- ─────────────────────────────────────────────
vim.g.autoformat = true
vim.g.snacks_animate = true
vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }
vim.g.root_lsp_ignore = { "copilot" }
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
