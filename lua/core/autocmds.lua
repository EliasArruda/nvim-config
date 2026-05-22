local function augroup(name)
	return vim.api.nvim_create_augroup("core_" .. name, { clear = true })
end

-- ─────────────────────────────────────────────
-- 🔄 FILE SYNC
-- Automatically check and reload files changed outside Neovim
-- ─────────────────────────────────────────────
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = augroup("checktime"),
	callback = function()
		if vim.o.buftype ~= "nofile" then
			vim.cmd.checktime()
		end
	end,
})

-- ─────────────────────────────────────────────
-- ✨ YANK HIGHLIGHT
-- Visually highlight text after yanking (copying)
-- ─────────────────────────────────────────────
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup("highlight_yank"),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- ─────────────────────────────────────────────
-- 🪟 WINDOW RESIZE HANDLING
-- Keep all splits properly balanced when resizing Neovim
-- ─────────────────────────────────────────────
vim.api.nvim_create_autocmd("VimResized", {
	group = augroup("resize_splits"),
	callback = function()
		-- Percorre apenas as janelas da aba atual, sem usar `tabdo` (mais eficiente)
		local wins = vim.api.nvim_tabpage_list_wins(0)
		for _, win in ipairs(wins) do
			if vim.api.nvim_win_is_valid(win) then
				vim.api.nvim_win_call(win, function()
					vim.cmd("wincmd =")
				end)
			end
		end
	end,
})

-- ─────────────────────────────────────────────
-- 📍 RESTORE CURSOR POSITION
-- Restore last cursor position when reopening a file
-- ─────────────────────────────────────────────
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup("last_loc"),
	callback = function(event)
		local exclude = { "gitcommit" }
		local buf = event.buf

		if vim.tbl_contains(exclude, vim.bo[buf].filetype) then
			return
		end

		local ok, mark = pcall(vim.api.nvim_buf_get_mark, buf, '"')
		if not ok then
			return
		end

		local line_count = vim.api.nvim_buf_line_count(buf)

		if mark[1] > 0 and mark[1] <= line_count then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- ─────────────────────────────────────────────
-- ❌ CLOSE SPECIAL BUFFERS
-- Enable quick closing of utility buffers using "q"
-- ─────────────────────────────────────────────
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("close_with_q"),
	pattern = {
		"PlenaryTestPopup",
		"checkhealth",
		"dap-float",
		"dbout",
		"gitsigns-blame",
		"grug-far",
		"help",
		"lspinfo",
		"man",
		"neotest-output",
		"neotest-output-panel",
		"neotest-summary",
		"notify",
		"qf",
		"spectre_panel",
		"startuptime",
		"tsplayground",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false

		vim.keymap.set("n", "q", function()
				vim.cmd.close()
			pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
		end, {
			buffer = event.buf,
			silent = true,
			desc = "Close buffer",
		})
	end,
})

-- ─────────────────────────────────────────────
-- ✍️ TEXT FILE MODE
-- Enable wrapping and spell checking for text-based files
-- ─────────────────────────────────────────────
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("wrap_spell"),
	pattern = { "markdown", "text", "gitcommit" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

-- ─────────────────────────────────────────────
-- 📄 JSON READABILITY MODE
-- Improve JSON readability by disabling conceal
-- ─────────────────────────────────────────────
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("json"),
	pattern = { "json", "jsonc" },
	callback = function()
		vim.opt_local.conceallevel = 0
	end,
})

-- ─────────────────────────────────────────────
-- 🔤 TEMPL FILETYPE
-- Ensure .templ files are detected for Go templating
-- ─────────────────────────────────────────────
vim.filetype.add({ extension = { templ = "templ" } })

-- ─────────────────────────────────────────────
-- 📁 AUTO DIRECTORY CREATION
-- Automatically create missing directories when saving files
-- ─────────────────────────────────────────────
vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup("mkdir"),
	callback = function(event)
		local file = vim.fs.normalize(event.match)
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})
