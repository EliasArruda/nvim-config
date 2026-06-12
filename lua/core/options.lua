vim.g.mapleader = " "

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
opt.smartindent = true

-- ─────────────────────────────────────────────
-- 📝 FOLDING
-- ─────────────────────────────────────────────
opt.foldlevel = 99
opt.foldmethod = "indent"
opt.foldtext = ""
opt.fillchars = {
	foldopen = "",
	foldclose = "",
	fold = " ",
	foldsep = " ",
	diff = "╱",
	eob = " ",
}

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
opt.number = false
opt.relativenumber = false
opt.signcolumn = "no"
opt.termguicolors = true
opt.cursorline = true
opt.laststatus = 3
opt.showmode = false
opt.ruler = false
opt.list = true
opt.linebreak = true
opt.mouse = "a"
opt.scrolloff = 4
opt.sidescrolloff = 8
opt.smoothscroll = true
opt.pumblend = 10
opt.pumheight = 10
opt.winminwidth = 5
opt.wrap = false
opt.spelllang = { "en" }
opt.formatoptions = "jcoqlnt"
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.splitbelow = true
opt.splitkeep = "screen"
opt.splitright = true
opt.jumpoptions = "view"
opt.virtualedit = "block"
opt.wildmode = "longest:full,full"
opt.timeoutlen = 300
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

vim.g.markdown_recommended_style = 0
