local M = {}
local busy = false

local function await(command, root)
	local thread = coroutine.running()
	vim.system(command, { cwd = root, text = true }, function(result)
		vim.schedule(function()
			coroutine.resume(thread, result)
		end)
	end)
	local result = coroutine.yield()
	local output = (result.stdout or "") .. (result.stderr or "")
	local log = vim.fn.stdpath("state") .. "/cpp-build.log"
	vim.fn.mkdir(vim.fs.dirname(log), "p")
	vim.fn.writefile(vim.split(table.concat(command, " ") .. "\n" .. output, "\n"), log, "a")
	if result.code ~= 0 then
		vim.fn.setqflist({}, " ", { title = "C/C++ build", lines = vim.split(output, "\n"), efm = vim.o.errorformat })
		vim.cmd.copen()
		error("C/C++ build failed. See quickfix and " .. log, 0)
	end
end

local function read_json(path)
	return vim.json.decode(table.concat(vim.fn.readfile(path), "\n"))
end

local function cmake_program(root)
	local build = root .. "/build"
	local query = build .. "/.cmake/api/v1/query"
	vim.fn.mkdir(query, "p")
	vim.fn.writefile({}, query .. "/codemodel-v2")
	await({ "cmake", "-S", root, "-B", build, "-DCMAKE_BUILD_TYPE=Debug", "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON" }, root)
	local reply = build .. "/.cmake/api/v1/reply/"
	local indexes = vim.fn.glob(reply .. "index-*.json", false, true)
	table.sort(indexes)
	assert(#indexes > 0, "CMake did not provide a file-api reply")
	local index = read_json(indexes[#indexes])
	local model = read_json(reply .. index.reply["codemodel-v2"].jsonFile)
	local config = model.configurations[1]
	for _, candidate in ipairs(model.configurations) do
		if candidate.name == "Debug" then
			config = candidate
		end
	end
	local targets = {}
	for _, reference in ipairs(config.targets or {}) do
		local target = read_json(reply .. reference.jsonFile)
		if target.type == "EXECUTABLE" and target.artifacts and target.artifacts[1] then
			targets[#targets + 1] = { name = target.name, path = target.artifacts[1].path }
		end
	end
	assert(#targets > 0, "No executable CMake target found (add_executable)")
	local target = #targets == 1 and targets[1] or nil
	if not target then
		local thread = coroutine.running()
		vim.ui.select(targets, {
			prompt = "C++ debug target",
			format_item = function(item)
				return item.name
			end,
		}, function(item)
			vim.schedule(function()
				coroutine.resume(thread, item or false)
			end)
		end)
		target = coroutine.yield()
	end
	if not target then
		return require("dap").ABORT
	end
	await({ "cmake", "--build", build, "--config", "Debug", "--target", target.name }, root)
	return target.path:sub(1, 1) == "/" and target.path or vim.fs.abspath(build .. "/" .. target.path)
end

function M.program()
	local buf = vim.api.nvim_get_current_buf()
	local source = vim.api.nvim_buf_get_name(0)
	local root = require("core.project").root()
	local filetype = vim.bo.filetype
	return coroutine.create(function(dap_thread)
		if busy then
			vim.notify("C/C++ build already running", vim.log.levels.WARN)
			coroutine.resume(dap_thread, require("dap").ABORT)
			return
		end
		busy = true
		local ok, program = pcall(function()
			vim.api.nvim_buf_call(buf, function()
				vim.cmd("silent update")
			end)
			vim.notify("Building C/C++ for debugging…")
			if vim.uv.fs_stat(root .. "/CMakeLists.txt") then
				return cmake_program(root)
			end
			assert(
				vim.tbl_contains({ "c", "cpp", "cc", "cxx", "C" }, vim.fn.fnamemodify(source, ":e")),
				"Open a C/C++ source file, or use a CMake project for headers"
			)
			local directory = vim.fn.stdpath("cache") .. "/cpp-debug/" .. vim.fn.sha256(source)
			vim.fn.mkdir(directory, "p")
			local output = directory .. "/program"
			local compiler = filetype == "c" and "cc" or "c++"
			await({ compiler, "-g", "-O0", source, "-o", output }, root)
			return output
		end)
		busy = false
		if not ok then
			vim.notify(tostring(program), vim.log.levels.ERROR)
			program = require("dap").ABORT
		end
		coroutine.resume(dap_thread, program)
	end)
end

return M
