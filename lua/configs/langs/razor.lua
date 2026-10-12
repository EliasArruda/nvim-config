local M = {}

local control_headers =
	{ ["if"] = true, ["for"] = true, foreach = true, ["while"] = true, switch = true, lock = true, using = true }
local function in_recovering_header(text)
	local keyword = text:match("^%s*@(%a+)%s*%(")
	if not control_headers[keyword] then
		return false
	end
	local depth, quote, i = 0, nil, text:find("(", 1, true)
	while i <= #text do
		local char = text:sub(i, i)
		if quote then
			if char == "\\" then
				i = i + 1
			elseif char == quote then
				quote = nil
			end
		elseif char == '"' or char == "'" then
			quote = char
		elseif char == "(" then
			depth = depth + 1
		elseif char == ")" then
			depth = depth - 1
			if depth == 0 then
				return text:sub(i + 1):match("^%s*$") ~= nil
			end
		end
		i = i + 1
	end
	return true
end

-- A bounded fallback is needed while Razor's parser is recovering from a tag.
-- Use the Razor tree to avoid treating C# generics and strings as HTML.
function M.is_code_or_comment(bufnr, cursor)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	cursor = cursor or vim.api.nvim_win_get_cursor(0)
	local row, col = cursor[1] - 1, cursor[2]
	local ok, node = pcall(vim.treesitter.get_node, {
		bufnr = bufnr,
		pos = { row, math.max(0, col - 1) },
		ignore_injections = true,
	})
	if ok then
		while node do
			local kind = node:type()
			if kind == "razor_foreach" or kind == "razor_for" or kind == "razor_lock" or kind == "razor_catch" then
				for child in node:iter_children() do
					if child:type() == "{" then
						local open_row, open_col = child:start()
						if row < open_row or (row == open_row and col <= open_col) then
							return true
						end
						break
					end
				end
			end
			if kind == "ERROR" then
				local text = vim.treesitter.get_node_text(node, bufnr)
				local start_row, start_col = node:start()
				local prefix = table.concat(vim.api.nvim_buf_get_text(bufnr, start_row, start_col, row, col, {}), "\n")
				if in_recovering_header(prefix) then
					return true
				end
				if text:match("^%s*@code%s*{") or text:match("^%s*@functions%s*{") then
					return true
				end
			end
			if
				kind == "razor_block"
				or kind == "razor_condition"
				or kind == "razor_case_condition"
				or kind == "razor_explicit_expression"
				or (kind == "razor_implicit_expression" and vim.treesitter.get_node_text(node, bufnr):match("^@"))
				or kind == "razor_attribute_value"
				or kind:find("comment", 1, true)
			then
				return true
			end
			node = node:parent()
		end
	end
	return false
end

function M.in_tag(bufnr, cursor)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	cursor = cursor or vim.api.nvim_win_get_cursor(0)
	if M.is_code_or_comment(bufnr, cursor) then
		return false
	end
	local row, col = cursor[1] - 1, cursor[2]
	local lines = vim.api.nvim_buf_get_lines(bufnr, math.max(0, row - 80), row + 1, false)
	if #lines == 0 then
		return false
	end
	lines[#lines] = lines[#lines]:sub(1, col)
	local text = table.concat(lines, "\n")
	local active, quote, comment, i = false, nil, nil, 1
	while i <= #text do
		local char = text:sub(i, i)
		if comment then
			if text:sub(i, i + #comment - 1) == comment then
				i, comment = i + #comment, nil
			else
				i = i + 1
			end
		elseif quote then
			if char == quote then
				quote = nil
			end
			i = i + 1
		elseif text:sub(i, i + 3) == "<!--" then
			comment, i = "-->", i + 4
		elseif text:sub(i, i + 1) == "@*" then
			comment, i = "*@", i + 2
		elseif active and (char == '"' or char == "'") then
			quote, i = char, i + 1
		elseif char == ">" then
			active, i = false, i + 1
		elseif char == "<" then
			local name = text:sub(i + 1):match("^([%a_][%w_:.-]*)")
			active, i = name ~= nil, i + 1
		else
			i = i + 1
		end
	end
	return active and not quote and not comment
end

local configured = false
function M.setup()
	vim.api.nvim_create_autocmd("FileType", {
		group = vim.api.nvim_create_augroup("blazor_editing", { clear = true }),
		pattern = "razor",
		callback = function(event)
			if not configured then
				-- Resolve inherited queries before replacing only unsafe combining.
				local sources, seen = {}, {}
				for _, file in ipairs(vim.treesitter.query.get_files("razor", "injections")) do
					if not seen[file] then
						local content = table.concat(vim.fn.readfile(file), "\n")
						if vim.fs.normalize(file):find("/razor/", 1, true) then
							content = content:gsub("%(#set! injection%.combined%)", "")
						end
						sources[#sources + 1], seen[file] = content, true
					end
				end
				local source = table.concat(sources, "\n")
				-- When a malformed opening tag becomes a top-level ERROR, retain
				-- its recognizable HTML. Never inject HTML into errors inside C#.
				source = source
					.. [[
(compilation_unit
  (ERROR) @injection.content
  (#lua-match? @injection.content "^%s*<")
  (#set! injection.language "html"))
]]
				vim.treesitter.query.set("razor", "injections", source)
				configured = true
			end
			vim.treesitter.language.add("html")
			vim.treesitter.start(event.buf, "razor")
		end,
	})
end

return M
