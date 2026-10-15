local template_group = vim.api.nvim_create_augroup("GoFileTemplates", { clear = true })

local function is_buffer_empty()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	return #lines == 1 and lines[1]:match("^%s*$") ~= nil
end

local function package_name(filename, directory)
	if filename == "main.go" then
		return "main"
	end

	for _, path in ipairs(vim.fn.glob(directory .. "/*.go", false, true)) do
		if vim.fn.fnamemodify(path, ":t") ~= filename and not path:match("_test%.go$") then
			for _, line in ipairs(vim.fn.readfile(path, "", 30)) do
				local existing = line:match("^package%s+([%w_]+)")
				if existing then
					return existing
				end
			end
		end
	end
	local name = vim.fn.fnamemodify(directory, ":t"):lower()
	name = name:gsub("[^%w]", ""):gsub("_", "")
	if name == "" then
		return "main"
	end
	if name:match("^%d") then
		name = "pkg" .. name
	end
	return name
end

local function run_template(event)
	local buf = event.buf
	vim.defer_fn(function()
		if not vim.api.nvim_buf_is_valid(buf) or vim.api.nvim_get_current_buf() ~= buf then
			return
		end
		local filename = vim.fn.expand("%:t")
		if filename == "" or not filename:match("%.go$") or not is_buffer_empty() then
			return
		end

		local package = package_name(filename, vim.fn.expand("%:p:h"))
		vim.api.nvim_buf_set_lines(0, 0, -1, false, { "package " .. package, "", "" })
		vim.api.nvim_win_set_cursor(0, { 3, 0 })
		vim.cmd("startinsert!")
	end, vim.g.vscode and 200 or 0)
end

vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost", "BufEnter" }, {
	pattern = "*.go",
	group = template_group,
	callback = function(args)
		if require("configs.templates.common").eligible(args) then
			run_template(args)
		end
	end,
})
