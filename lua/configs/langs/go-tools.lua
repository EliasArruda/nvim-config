local M = {}

-- Both tools emit a complete SARIF document; process output once, on exit.
function M.sarif_items(document, cwd)
	local items = {}
	for _, run in ipairs(document.runs or {}) do
		for _, result in ipairs(run.results or {}) do
			local locations = result.locations or {}
			if #locations == 0 then
				locations = { {} }
			end
			for _, location in ipairs(locations) do
				local physical = location.physicalLocation or {}
				local artifact = physical.artifactLocation or {}
				local path = artifact.uri
				if path and path:match("^file:") then
					path = vim.uri_to_fname(path)
				elseif path then
					path = path:gsub("%%(%x%x)", function(hex)
						return string.char(tonumber(hex, 16))
					end)
					if not vim.startswith(path, "/") then
						path = vim.fs.joinpath(cwd, path)
					end
				end
				local region = physical.region or {}
				items[#items + 1] = {
					filename = path,
					lnum = region.startLine or 1,
					col = region.startColumn or 1,
					text = (result.ruleId or "")
						.. ": "
						.. ((result.message or {}).text or (result.message or {}).markdown or "Finding"),
					type = result.level == "error" and "E" or "W",
				}
			end
		end
	end
	return items
end

function M.run(cmd, name)
	if vim.fn.executable(cmd[1]) == 0 then
		vim.notify(name .. " executable not found; see README prerequisites", vim.log.levels.ERROR)
		return
	end
	local cwd = vim.fs.root(0, "go.mod") or vim.uv.cwd()
	vim.system(cmd, { cwd = cwd, text = true }, function(result)
		vim.schedule(function()
			local ok, document = pcall(vim.json.decode, result.stdout or "")
			if not ok or type(document) ~= "table" or type(document.runs) ~= "table" then
				vim.notify(
					name .. ": " .. (result.stderr ~= "" and result.stderr or result.stdout or "No report"),
					vim.log.levels.ERROR
				)
				return
			end
			local items = M.sarif_items(document, cwd)
			vim.fn.setqflist({}, " ", { title = name, items = items })
			if #items > 0 then
				vim.cmd.copen()
			elseif result.code == 0 then
				vim.notify(name .. ": no findings")
			else
				vim.notify(name .. " failed: " .. (result.stderr or "exit " .. result.code), vim.log.levels.ERROR)
			end
		end)
	end)
end
return M
