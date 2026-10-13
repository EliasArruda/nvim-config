local buf = vim.api.nvim_create_buf(true, false)
vim.api.nvim_set_current_buf(buf)
vim.api.nvim_buf_set_lines(
	buf,
	0,
	-1,
	false,
	{ "public string Name { get; set; }", "public string Email { get; set; }" }
)
vim.diagnostic.config({ virtual_lines = { current_line = true }, virtual_text = false, update_in_insert = true })
local a = vim.api.nvim_create_namespace("test.diagnostics.a")
local b = vim.api.nvim_create_namespace("test.diagnostics.b")
local warning = {
	lnum = 0,
	col = 14,
	end_lnum = 0,
	end_col = 18,
	severity = vim.diagnostic.severity.WARN,
	code = "CS8618",
	message = "Name must contain a non-null value",
}
local checks = 0
local function check(value, message)
	assert(value, message)
	checks = checks + 1
end
local function lines()
	local result = {}
	for _, mark in ipairs(vim.api.nvim_buf_get_extmarks(buf, -1, 0, -1, { details = true })) do
		for _, line in ipairs(mark[4].virt_lines or {}) do
			local text = {}
			for _, chunk in ipairs(line) do
				text[#text + 1] = chunk[1]
			end
			result[#result + 1] = table.concat(text)
		end
	end
	return result
end
vim.diagnostic.set(a, buf, { warning, vim.deepcopy(warning) })
vim.diagnostic.set(b, buf, { vim.deepcopy(warning) })
check(#lines() == 1, "Duplicate diagnostics within/across providers render once")
check(#vim.diagnostic.get(buf) == 3, "Original diagnostic caches preserved")
check(require("config.diagnostics").counts(buf).warn == 1, "Status/Tab counters count unique diagnostics")
vim.diagnostic.reset(a, buf)
check(#lines() == 1, "Removing first provider retains warning from other provider")
local other = vim.deepcopy(warning)
other.code, other.message = "CS0103", "Unknown identifier"
vim.diagnostic.set(a, buf, { other })
check(#lines() == 2, "Different warnings at same location remain visible")
vim.diagnostic.enable(false, { bufnr = buf, ns_id = a })
check(#lines() == 1, "Disabled namespace excluded")
vim.diagnostic.enable(true, { bufnr = buf, ns_id = a })
check(#lines() == 2, "Reenabled namespace restored")
vim.diagnostic.config({ virtual_lines = false })
check(#lines() == 0, "Disabling virtual lines clears aggregate")
vim.diagnostic.config({ virtual_lines = { current_line = true } })
check(#lines() == 2, "Reenabling virtual lines restores unique messages")
local email = vim.deepcopy(warning)
email.lnum, email.end_lnum, email.message = 1, 1, "Email must contain a non-null value"
vim.diagnostic.set(a, buf, { other, email })
vim.api.nvim_win_set_cursor(0, { 2, 0 })
vim.api.nvim_exec_autocmds("CursorMoved", { buffer = buf })
check(#lines() == 1 and lines()[1]:find("Email", 1, true), "Moving cursor renders correct line")
vim.diagnostic.reset(a, buf)
vim.diagnostic.reset(b, buf)
check(#lines() == 0, "Reset clears stale warning")

vim.api.nvim_win_set_cursor(0, { 1, 0 })
local format_a = function(d)
	return "A:" .. d.message
end
local format_b = function(d)
	return "B:" .. d.message
end
vim.diagnostic.config({ virtual_lines = { current_line = true, format = format_a } }, a)
vim.diagnostic.config({ virtual_lines = { current_line = false, format = format_b } }, b)
vim.diagnostic.set(a, buf, { other })
vim.diagnostic.set(b, buf, { email })
local text = table.concat(lines(), "\n")
check(
	text:find("A:Unknown identifier", 1, true) and text:find("B:Email", 1, true),
	"Provider-specific formatting preserved"
)
check(#lines() == 2, "Provider-specific current_line=false preserved")
vim.diagnostic.reset(a, buf)
vim.diagnostic.reset(b, buf)
vim.api.nvim_buf_delete(buf, { force = true })
print(("PASS: %d diagnostics checks"):format(checks))
