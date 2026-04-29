local M = {}

-- Helper: Parse Cargo's JSON output to find the executable binary
local function parse_cargo_metadata(cargo_metadata)
	for i = #cargo_metadata, 1, -1 do
		local line = cargo_metadata[i]
		if line and string.len(line) ~= 0 then
			local ok, json_table = pcall(vim.fn.json_decode, line)
			if ok and json_table["reason"] == "compiler-artifact" and json_table["executable"] ~= vim.NIL then
				return json_table["executable"]
			end
		end
	end
	return nil
end

-- Helper: Run cargo build and extract the binary path
local function cargo_inspector(config)
	local final_config = vim.deepcopy(config)

	-- 1. Setup compiler message window
	local compiler_msg_buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_option(compiler_msg_buf, "buftype", "nofile")
	local window_width = math.max(#(final_config.name or "Cargo"), 50)
	local window_height = 10
	local compiler_msg_window = vim.api.nvim_open_win(compiler_msg_buf, false, {
		relative = "editor",
		width = window_width,
		height = window_height,
		col = vim.api.nvim_get_option "columns" - window_width - 1,
		row = vim.api.nvim_get_option "lines" - window_height - 1,
		border = "rounded",
		style = "minimal",
	})

	vim.fn.appendbufline(compiler_msg_buf, "$", "🦀 Compiling Rust project...")
	vim.fn.appendbufline(compiler_msg_buf, "$", string.rep("=", window_width - 1))

	-- 2. Prepare cargo command
	local message_format = "--message-format=json"
	if final_config.cargo and final_config.cargo.args then
		table.insert(final_config.cargo.args, message_format)
	else
		final_config.cargo = { args = { message_format } }
	end

	local cargo_cmd = { "cargo" }
	if final_config.cargo and final_config.cargo.args then
		for _, value in pairs(final_config.cargo.args) do
			table.insert(cargo_cmd, value)
		end
	end

	-- 3. Execute Cargo
	local compiler_metadata = {}
	local cargo_job = vim.fn.jobstart(cargo_cmd, {
		cwd = final_config.cwd,
		stdout_buffered = true,
		on_stdout = function(_, data) compiler_metadata = data end,
		on_stderr = function(_, data)
			for _, partial_line in ipairs(data) do
				if string.len(partial_line) ~= 0 then
					vim.fn.appendbufline(compiler_msg_buf, "$", partial_line)
				end
			end
			vim.cmd "redraw"
		end,
		on_exit = function(_, exit_code)
			if vim.api.nvim_win_is_valid(compiler_msg_window) then
				vim.api.nvim_win_close(compiler_msg_window, { force = true })
			end
			if vim.api.nvim_buf_is_valid(compiler_msg_buf) then
				vim.api.nvim_buf_delete(compiler_msg_buf, { force = true })
			end

			if exit_code == 0 then
				local executable_name = parse_cargo_metadata(compiler_metadata)
				if executable_name then
					final_config.program = executable_name
				else
					vim.notify("DAP Error: Cargo succeeded but no executable was found", vim.log.levels.ERROR)
				end
			else
				vim.notify("DAP Error: Cargo build failed with exit code " .. exit_code, vim.log.levels.ERROR)
			end
		end,
	})

	-- 4. Source Maps (Standard Library)
	local rust_hash = ""
	local rust_hash_stdout = {}
	vim.fn.jobstart({ "rustc", "--version", "--verbose" }, {
		stdout_buffered = true,
		on_stdout = function(_, data) rust_hash_stdout = data end,
		on_exit = function()
			for _, line in pairs(rust_hash_stdout) do
				local start, finish = string.find(line, "commit-hash: ", 1, true)
				if start then rust_hash = string.sub(line, finish + 1) end
			end
		end,
	})

	local rust_source_path = ""
	vim.fn.jobstart({ "rustc", "--print", "sysroot" }, {
		stdout_buffered = true,
		on_stdout = function(_, data) rust_source_path = data[1] end,
	})

	vim.fn.jobwait { cargo_job }

	rust_hash = "/rustc/" .. rust_hash .. "/"
	rust_source_path = rust_source_path .. "/lib/rustlib/src/rust/"
	if final_config.sourceMap == nil then final_config["sourceMap"] = {} end
	final_config.sourceMap[rust_hash] = rust_source_path
	final_config.cargo = nil

	-- Validate path before returning
	if final_config.program and vim.fn.executable(final_config.program) == 0 then
		vim.notify("DAP Error: Binary not found or not executable: " .. tostring(final_config.program), vim.log.levels.ERROR)
	end

	return final_config
end

function M.setup()
	local dap = require("dap")

	-- 🦀 RUST (Professional Setup with Cargo Inspector)
	dap.adapters.codelldb = {
		type = "server",
		port = "${port}",
		executable = {
			command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
			args = { "--port", "${port}" },
		},
		enrich_config = function(config, on_config)
			if config["cargo"] ~= nil then
				on_config(cargo_inspector(config))
			end
		end,
	}

	dap.configurations.rust = {
		{
			name = "Debug (Cargo)",
			type = "codelldb",
			request = "launch",
			program = "${cargo:program}",
			cwd = "${workspaceFolder}",
			cargo = {
				args = { "build" },
			},
			sourceLanguages = { "rust" },
		},
	}

	-- 🎯 C# (.NET Core)
	dap.adapters.netcoredbg = {
		type = "executable",
		command = vim.fn.stdpath("data") .. "/mason/bin/netcoredbg",
		args = { "--interpreter=vscode" },
	}

	dap.configurations.cs = {
		{
			name = "Launch",
			type = "netcoredbg",
			request = "launch",
			cwd = "${workspaceFolder}",
			console = "integratedTerminal",
			program = function()
				local default_path = vim.fn.getcwd() .. "/bin/Debug/net8.0/"
				local input = vim.fn.input("Path to dll: ", default_path)
				if vim.fn.isdirectory(input) == 1 then
					local files = vim.fn.readdir(input)
					if files then
						local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
						for _, file in ipairs(files) do
							if file:lower():match(project_name:lower()) and file:match("%.dll$") then
								return input .. "/" .. file
							end
						end
					end
				end
				return input
			end,
		},
	}
end

return M
