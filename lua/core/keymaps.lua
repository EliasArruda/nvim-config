local map = vim.keymap.set

-- ============================================================
-- 📟 TERMINAL
-- ============================================================

vim.api.nvim_create_autocmd({ "TermOpen", "BufWinEnter" }, {
	pattern = "term://*",
	callback = function()
		local win = vim.api.nvim_get_current_win()
		local total = vim.o.lines
		local target = math.floor(total * 0.35)
		vim.api.nvim_win_set_height(win, target)
		vim.wo[win].winfixheight = true
	end,
})

local terminal_layout = nil
map({ "n", "t", "i" }, "<C-t>", function()
	local terminals = {}
	for count = 1, 10 do
		local term = Snacks.terminal.get(nil, { count = count, create = false })
		if term and term.win and vim.api.nvim_win_is_valid(term.win) then
			table.insert(terminals, { count = count, win = term.win, buf = term.buf })
		end
	end

	if vim.tbl_isempty(terminals) then
		if terminal_layout then
			for _, t in ipairs(terminal_layout) do
				Snacks.terminal.toggle(nil, {
					count = t.count,
					win = t.win_opts,
				})
			end
			terminal_layout = nil
		else
			Snacks.terminal.toggle(nil, {
				count = 1,
				win = { position = "bottom", height = 0.35 },
			})
		end
	else
		terminal_layout = {}
		for _, t in ipairs(terminals) do
			local w = t.win
			local opts = {
				position = "bottom",
				height = vim.api.nvim_win_get_height(w) / vim.o.lines,
				wo = { winfixwidth = vim.wo[w].winfixwidth },
			}
			local cfg = vim.api.nvim_win_get_config(w)
			if cfg.split then
				opts.split = cfg.split
				opts.position = cfg.split == "vertical" and "right" or "bottom"
			end
			table.insert(terminal_layout, { count = t.count, win_opts = opts })
		end

		for i = #terminals, 1, -1 do
			Snacks.terminal.toggle(nil, { count = terminals[i].count })
		end
	end
end, { desc = "Toggle Terminal (Todos os Splits)" })

map("t", "<C-n>", function()
	local count = 2
	while Snacks.terminal.get(nil, { count = count, create = false }) do
		count = count + 1
	end
	Snacks.terminal.get(nil, {
		count = count,
		win = {
			position = "bottom",
			split = "vertical",
			wo = { winfixwidth = true },
		},
	})
end, { desc = "New Terminal Split" })

-- LazyVim: terminal focus
map({ "n", "t" }, "<c-/>", function()
	Snacks.terminal.focus(nil, { cwd = vim.fn.getcwd() })
end, { desc = "Terminal (Root Dir)" })

-- ============================================================
-- 🪟 WINDOW NAVIGATION (LazyVim)
-- ============================================================
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })

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
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- ============================================================
-- 💾 EDITOR
-- ============================================================
map({ "n", "i", "v", "x" }, "<C-s>", "<Esc><Cmd>update<CR>", { desc = "Save", silent = true })

map("n", "<C-x>", function()
	vim.api.nvim_buf_delete(0, { force = true })
end, { desc = "Close Buffer" })

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
			float = true,
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
pcall(function()
	Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
	Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
	Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
	Snacks.toggle.diagnostics():map("<leader>ud")
	Snacks.toggle.line_number():map("<leader>ul")
	Snacks.toggle.option("conceallevel", {
		off = 0,
		on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2,
		name = "Conceal Level",
	}):map("<leader>uc")
	Snacks.toggle.option("showtabline", {
		off = 0,
		on = vim.o.showtabline > 0 and vim.o.showtabline or 2,
		name = "Tabline",
	}):map("<leader>uA")
	Snacks.toggle.treesitter():map("<leader>uT")
	Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
	Snacks.toggle.dim():map("<leader>uD")
	Snacks.toggle.animate():map("<leader>ua")
	Snacks.toggle.scroll():map("<leader>uS")
	Snacks.toggle.zoom():map("<leader>uZ")
	Snacks.toggle.zen():map("<leader>uz")

	if vim.lsp.inlay_hint then
		Snacks.toggle.inlay_hints():map("<leader>uh")
	end
end)

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

map("n", "<leader>r", function()
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
map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
