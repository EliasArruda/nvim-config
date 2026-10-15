local manager = require("core.terminals")
local checks = 0
local function check(value, label)
	assert(value, label)
	checks = checks + 1
end
local function shells()
	local list = vim.tbl_filter(function(t)
		return t.cmd == nil
	end, Snacks.terminal.list())
	table.sort(list, function(a, b)
		return a.buf < b.buf
	end)
	return list
end
local function counts()
	local terminals, sidebars = 0, 0
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		terminals = terminals + (vim.bo[buf].buftype == "terminal" and 1 or 0)
		sidebars = sidebars + (vim.bo[buf].filetype == "terminal_sessions" and 1 or 0)
	end
	return terminals, sidebars
end
manager.toggle()
check(#shells() == 1 and counts() == 1, "First toggle starts one shell")
manager.new_split()
vim.wait(80, function()
	return false
end)
local list = shells()
manager.select_number(1)
check(vim.api.nvim_get_current_buf() == list[1].buf, "Alt-number selector matches first list entry")
manager.select_number(2)
check(vim.api.nvim_get_current_buf() == list[2].buf, "Alt-number selector matches second list entry")
check(vim.fn.maparg("<M-1>", "t", false, true).buffer == 1, "Alt-number shortcuts are local to terminal buffers")
manager.select_number(9)
check(vim.api.nvim_get_current_buf() == list[2].buf, "Missing terminal number leaves selection unchanged")
local t, s = counts()
check(#list == 2 and t == 1 and s == 1, "Two sessions share one terminal and sidebar")
local jobs = { vim.b[list[1].buf].terminal_job_id, vim.b[list[2].buf].terminal_job_id }
check(vim.fn.jobwait(jobs, 0)[1] == -1 and vim.fn.jobwait(jobs, 0)[2] == -1, "Both shells keep running")
manager.select(list[1])
check(vim.api.nvim_get_current_buf() == list[1].buf, "Selecting first shell focuses its terminal")
check(counts() == 1, "Switching sessions does not create parallel terminal panes")
vim.api.nvim_win_set_height(list[1].win, vim.api.nvim_win_get_height(list[1].win) + 1)
local resized = vim.api.nvim_win_get_height(list[1].win)
manager.select(list[2])
check(vim.api.nvim_win_get_height(list[2].win) == resized, "Switching sessions preserves manually resized panel height")
manager.select(list[1])
manager.toggle()
check(counts() == 0, "Ctrl+T equivalent hides panel")
local command = Snacks.terminal.open({ "sh", "-c", "sleep 30" }, { interactive = false })
check(command:win_valid(), "External command terminal starts independently")
manager.toggle()
check(not command:win_valid() and counts() == 0, "Ctrl+T still hides external command terminals")
manager.toggle()
check(
	command:win_valid() and counts() == 1 and select(2, counts()) == 0,
	"Restoring external command does not open shell panel"
)
command:close()
check(vim.fn.jobwait(jobs, 0)[1] == -1 and vim.fn.jobwait(jobs, 0)[2] == -1, "Hidden shells remain alive")
manager.toggle()
check(vim.api.nvim_get_current_buf() == list[1].buf, "Toggle restores last selected shell")
check(select(2, counts()) == 1, "Sidebar restored with panel")
local sidebar
for _, win in ipairs(vim.api.nvim_list_wins()) do
	if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "terminal_sessions" then
		sidebar = win
	end
end
vim.api.nvim_set_current_win(sidebar)
local floating = vim.api.nvim_open_win(
	vim.api.nvim_create_buf(false, true),
	false,
	{ relative = "editor", row = 1, col = 1, width = 5, height = 1 }
)
vim.api.nvim_win_close(floating, true)
vim.wait(80, function()
	return false
end)
check(vim.api.nvim_get_current_win() == sidebar, "Closing unrelated UI preserves sidebar keyboard focus")
manager.select(list[1])
manager.new_split()
list = shells()
check(#list == 3 and counts() == 1, "Third shell also shares the panel")
vim.api.nvim_chan_send(vim.b[list[3].buf].terminal_job_id, "exit\n")
vim.wait(4000, function()
	return #shells() == 2
end)
check(#shells() == 2 and counts() == 1, "Closing active shell shows a surviving session")
local survivors = shells()
local surviving_job = vim.b[survivors[1].buf].terminal_job_id
manager.select(survivors[2])
vim.api.nvim_chan_send(vim.b[survivors[2].buf].terminal_job_id, "exit\n")
vim.wait(4000, function()
	return #shells() == 1
end)
check(#shells() == 1 and counts() == 1, "Exiting second of two sessions keeps final terminal visible")
check(select(2, counts()) == 0, "Sidebar disappears when one shell remains")
check(vim.fn.jobwait({ surviving_job }, 0)[1] == -1, "Exit does not terminate surviving shell")
manager.new_split()
local failing = shells()[2]
vim.api.nvim_chan_send(vim.b[failing.buf].terminal_job_id, "exit 7\n")
vim.wait(4000, function()
	return #shells() == 1
end)
check(#shells() == 1 and counts() == 1, "Nonzero shell exit also closes only its own session")
check(vim.fn.jobwait({ surviving_job }, 0)[1] == -1, "Surviving process is untouched after nonzero exit")
manager.new_split()
local hidden_shell = shells()[2]
manager.toggle()
vim.api.nvim_chan_send(vim.b[hidden_shell.buf].terminal_job_id, "exit\n")
vim.wait(4000, function()
	return #shells() == 1
end)
check(#shells() == 1 and counts() == 0, "Exit while panel is hidden does not reopen or close other sessions")
check(vim.fn.jobwait({ surviving_job }, 0)[1] == -1, "Hidden survivor remains alive after other shell exits")
manager.toggle()
check(counts() == 1, "Hidden-panel exit still permits restoring surviving shell")
manager.toggle()
for _, term in ipairs(shells()) do
	vim.api.nvim_chan_send(vim.b[term.buf].terminal_job_id, "exit\n")
end
vim.wait(80, function()
	return false
end)
check(counts() == 0, "No orphan terminal/sidebar windows after cleanup")
print(("PASS: %d terminal panel checks"):format(checks))
