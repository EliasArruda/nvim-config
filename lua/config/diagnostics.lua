local M = {}

-- Keep the producers' diagnostic caches intact; deduplicate only the rendering.
function M.unique(diagnostics, severity_sort)
	local result, seen = {}, {}
	for _, diagnostic in ipairs(diagnostics) do
		local key = vim.json.encode({
			diagnostic.lnum,
			diagnostic.col,
			diagnostic.end_lnum or diagnostic.lnum,
			diagnostic.end_col or diagnostic.col,
			diagnostic.severity or vim.diagnostic.severity.ERROR,
			tostring(diagnostic.code or ""),
			diagnostic.message,
			diagnostic.source or "",
		})
		if not seen[key] then
			seen[key] = true
			result[#result + 1] = diagnostic
		end
	end
	if severity_sort ~= false then
		table.sort(result, function(a, b)
			if a.severity ~= b.severity then
				if type(severity_sort) == "table" and severity_sort.reverse then
					return a.severity > b.severity
				end
				return a.severity < b.severity
			end
			if a.lnum ~= b.lnum then
				return a.lnum < b.lnum
			end
			return a.col < b.col
		end)
	end
	return result
end

function M.counts(buf)
	local counts = { error = 0, warn = 0, info = 0, hint = 0 }
	local names = { "error", "warn", "info", "hint" }
	for _, diagnostic in ipairs(M.unique(vim.diagnostic.get(buf or 0))) do
		local name = names[diagnostic.severity]
		counts[name] = counts[name] + 1
	end
	return counts
end

local function fingerprint(value)
	if type(value) ~= "table" then
		if type(value) == "function" then
			return tostring(value)
		end
		return vim.json.encode(value)
	end
	local keys, parts = vim.tbl_keys(value), {}
	table.sort(keys, function(a, b)
		return tostring(a) < tostring(b)
	end)
	for _, key in ipairs(keys) do
		parts[#parts + 1] = fingerprint(key) .. ":" .. fingerprint(value[key])
	end
	return "{" .. table.concat(parts, ",") .. "}"
end

function M.setup()
	if M.installed then
		return
	end
	M.installed = true
	local original = vim.diagnostic.handlers.virtual_lines
	local buffers, rendered, namespaces, next_namespace = {}, {}, {}, 0
	local function render(buf)
		if not vim.api.nvim_buf_is_valid(buf) then
			buffers[buf], rendered[buf] = nil, nil
			return
		end
		for _, namespace in ipairs(rendered[buf] or {}) do
			original.hide(namespace, buf)
		end
		rendered[buf] = {}
		local sources, groups = buffers[buf] or {}, {}
		local ids = vim.tbl_keys(sources)
		table.sort(ids)
		for _, id in ipairs(ids) do
			local source = sources[id]
			-- Preserve per-provider formatting and current-line/severity settings.
			local key =
				fingerprint({ virtual_lines = source.opts.virtual_lines, severity_sort = source.opts.severity_sort })
			groups[key] = groups[key] or { diagnostics = {}, opts = source.opts }
			vim.list_extend(groups[key].diagnostics, source.diagnostics)
		end
		for key, group in pairs(groups) do
			if #group.diagnostics > 0 then
				if not namespaces[key] then
					next_namespace = next_namespace + 1
					namespaces[key] =
						vim.api.nvim_create_namespace("config.diagnostics.unique_virtual_lines." .. next_namespace)
				end
				local namespace = namespaces[key]
				local diagnostics = M.unique(group.diagnostics, group.opts.severity_sort)
				original.show(namespace, buf, diagnostics, group.opts)
				rendered[buf][#rendered[buf] + 1] = namespace
			end
		end
	end
	vim.diagnostic.handlers.virtual_lines = {
		show = function(source, buf, diagnostics, opts)
			buf = buf == 0 and vim.api.nvim_get_current_buf() or buf
			buffers[buf] = buffers[buf] or {}
			buffers[buf][source] = { diagnostics = diagnostics, opts = opts }
			render(buf)
		end,
		hide = function(source, buf)
			buf = buf == 0 and vim.api.nvim_get_current_buf() or buf
			if buffers[buf] then
				buffers[buf][source] = nil
			end
			render(buf)
		end,
	}
	vim.api.nvim_create_autocmd("BufWipeout", {
		group = vim.api.nvim_create_augroup("config_diagnostics_cleanup", { clear = true }),
		callback = function(event)
			buffers[event.buf], rendered[event.buf] = nil, nil
		end,
	})
end

return M
