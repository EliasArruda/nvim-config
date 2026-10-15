local map = vim.keymap.set

-- ============================================================
-- 📟 TERMINAL
-- ============================================================

map({ "n", "t", "i" }, "<C-t>", function()
	require("core.terminals").toggle()
end, { desc = "Toggle Terminals" })
map("t", "<C-n>", function()
	require("core.terminals").new_split()
end, { desc = "New Terminal Split" })

-- LazyVim: terminal focus
map({ "n", "t" }, "<c-/>", function()
	Snacks.terminal.focus(nil, { cwd = vim.fn.getcwd() })
end, { desc = "Terminal (Root Dir)" })

-- ============================================================
-- 🪟 WINDOW NAVIGATION (Smart-splits cuida disso)
-- ============================================================
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })

map("n", "<leader>nu", function()
	local ok_manager, manager = pcall(require, "easy-dotnet.terminal.manager")
	if not ok_manager then
		return
	end

	local server_tab = vim.iter(manager.get_all()):find(function(tab)
		return tab.owned_by == "server"
	end)
	if not server_tab then
		return
	end

	local panel_visible = manager.panel_win and vim.api.nvim_win_is_valid(manager.panel_win)
	local terminal = require("easy-dotnet.terminal")
	if panel_visible then
		terminal.hide()
	else
		manager.set_active(server_tab.id)
		terminal.show()
	end
end, { desc = ".NET Toggle run/watch/debug output" })

-- ============================================================
-- 📦 BUFFERS (LazyVim)
-- ============================================================
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>bd", function()
	Snacks.bufdelete()
end, { desc = "Delete Buffer" })
map("n", "<leader>bo", function()
	Snacks.bufdelete.other()
end, { desc = "Delete Other Buffers" })

-- ============================================================
-- 🔄 MOVE LINES (LazyVim)
-- ============================================================
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Line Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Line Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Line Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Line Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Line Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Line Up" })

-- NOTE: <A-h>/<A-l> são usados pelo smart-splits para redimensionar janelas

-- ============================================================
-- 💾 EDITOR
-- ============================================================
map({ "n", "i", "v", "x" }, "<C-s>", "<Esc><Cmd>update<CR>", { desc = "Save", silent = true })

map("n", "<C-x>", "<Cmd>bdelete!<CR>", { desc = "Force Close Buffer" })

-- Clear search on escape (LazyVim)
map({ "i", "n", "s" }, "<esc>", function()
	vim.cmd.noh()
	return "<esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" })

-- Redraw / clear hlsearch (LazyVim)
map("n", "<leader>ur", "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>", {
	desc = "Redraw / Clear hlsearch / Diff Update",
})

-- n/N with zv (open fold on search result) (LazyVim)
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })

-- ============================================================
-- 🔬 LSP
-- ============================================================

map({ "n", "i" }, "<C-.>", vim.lsp.buf.code_action, { desc = "Code Actions" })
map("n", "<C-CR>", vim.lsp.buf.definition, { desc = "Go to Definition" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Diagnostic Float" })

map("n", "<leader>cy", function()
	local diags = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
	if #diags == 0 then
		return
	end
	vim.fn.setreg("+", diags[1].message)
	vim.notify("Copied: " .. diags[1].message)
end, { desc = "Copy Diagnostic" })

-- Diagnostic jumps (LazyVim)
local diagnostic_goto = function(next, severity)
	return function()
		vim.diagnostic.jump({
			count = (next and 1 or -1) * vim.v.count1,
			severity = severity and vim.diagnostic.severity[severity] or nil,
			on_jump = function(diagnostic, bufnr)
				if diagnostic then
					vim.diagnostic.open_float(bufnr, { scope = "cursor" })
				end
			end,
		})
	end
end
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- ============================================================
-- ⚡ TOGGLES (LazyVim snacks)
-- ============================================================

-- ============================================================
-- 🔍 QUICKFIX / LOCATION (LazyVim)
-- ============================================================
map("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
map("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

-- ============================================================
-- 📑 TABS (LazyVim)
-- ============================================================
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- ============================================================
-- 🛠️ UTILITIES
-- ============================================================
map("n", "<leader>gx", function()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	for _, line in ipairs(lines) do
		local url = line:match("(https?:[%w%-%._~:/%?#%[%]@!$&'()*+,;=]+)")
		if url then
			vim.fn.jobstart({ "xdg-open", url }, { detach = true })
			vim.notify("Opening: " .. url)
			return
		end
	end
	vim.notify("❌ No URL found", vim.log.levels.WARN)
end, { desc = "Open URL" })

map("n", "<leader>uN", function()
	if vim.wo.number then
		vim.wo.number = false
		vim.wo.relativenumber = false
		vim.wo.signcolumn = "no"
	else
		vim.wo.number = true
		vim.wo.relativenumber = true
		vim.wo.signcolumn = "yes"
	end
end, { desc = "Toggle Line Numbers" })

map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })
if vim.show_pos then
	map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
end
