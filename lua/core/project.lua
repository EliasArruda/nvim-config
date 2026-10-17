local M = {}
local markers = {
	[".git"] = true,
	["package.json"] = true,
	["go.mod"] = true,
	["go.work"] = true,
	["Cargo.toml"] = true,
	["Gemfile"] = true,
	["mix.exs"] = true,
	["pyproject.toml"] = true,
	["pyrightconfig.json"] = true,
	["global.json"] = true,
	["CMakeLists.txt"] = true,
}
function M.root(source, extra_markers)
	source = source or vim.api.nvim_get_current_buf()
	local filetype = type(source) == "number" and vim.bo[source].filetype or vim.filetype.match({ filename = source })
	local effective = vim.tbl_extend("force", {}, markers)
	local function add(values)
		for _, value in ipairs(values or {}) do
			if type(value) == "table" then
				add(value)
			elseif type(value) == "string" then
				effective[value] = true
			end
		end
	end
	add(extra_markers)
	if filetype == "c" or filetype == "cpp" then
		add({ "compile_commands.json", "compile_flags.txt", ".clangd", "Makefile", "meson.build" })
	end
	if type(source) == "number" then
		local name = vim.api.nvim_buf_get_name(source)
		source = name ~= "" and vim.bo[source].buftype == "" and name or vim.fn.getcwd()
	end
	local path = vim.fs.normalize(source)
	local stat = vim.uv.fs_stat(path)
	local start = stat and stat.type == "directory" and path or vim.fs.dirname(path)
	local home = vim.fs.normalize(vim.env.HOME)
	local dir = start
	while dir do
		if dir == home and start ~= home then
			break
		end
		local found = false
		for name in
			(vim.uv.fs_stat(dir) and vim.fs.dir(dir) or function()
				return nil
			end)
		do
			if effective[name] or name:match("%.csproj$") or name:match("%.fsproj$") or name:match("%.slnx?$") then
				found = true
				break
			end
		end
		if found then
			return dir
		end
		local parent = vim.fs.dirname(dir)
		if parent == dir then
			break
		end
		dir = parent
	end
	return start or vim.fn.getcwd()
end
function M.package_manager(root)
	local package = root .. "/package.json"
	local ok, data = pcall(function()
		return vim.json.decode(table.concat(vim.fn.readfile(package), "\n"))
	end)
	if ok and type(data) == "table" and type(data.packageManager) == "string" then
		local name = data.packageManager:match("^(%a+)@")
		if vim.tbl_contains({ "npm", "pnpm", "yarn", "bun" }, name) then
			return name
		end
	end
	local dir = root
	while dir and dir ~= vim.env.HOME do
		for _, entry in ipairs({
			{ "bun.lock", "bun" },
			{ "bun.lockb", "bun" },
			{ "pnpm-lock.yaml", "pnpm" },
			{ "pnpm-workspace.yaml", "pnpm" },
			{ "yarn.lock", "yarn" },
			{ "package-lock.json", "npm" },
		}) do
			if vim.uv.fs_stat(dir .. "/" .. entry[1]) then
				return entry[2]
			end
		end
		if vim.uv.fs_stat(dir .. "/.git") then
			break
		end
		local parent = vim.fs.dirname(dir)
		if parent == dir then
			break
		end
		dir = parent
	end
	return "npm"
end
return M
