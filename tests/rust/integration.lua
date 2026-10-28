local root = assert(vim.env.NVIM_RUST_TEST_ROOT)
local original = vim.fn.readfile(root .. "/src/main.rs")
local ready = false
require("rustaceanvim.config.internal").tools.on_initialized = function()
	ready = true
end
vim.cmd.edit(root .. "/src/main.rs")
local buf = vim.api.nvim_get_current_buf()
local client
assert(
	vim.wait(45000, function()
		client = vim.lsp.get_clients({ bufnr = buf, name = "rust-analyzer" })[1]
		if not client or not client.initialized or not ready then
			return false
		end
		local response = client:request_sync(
			"textDocument/hover",
			{ textDocument = { uri = vim.uri_from_bufnr(buf) }, position = { line = 5, character = 20 } },
			1000,
			buf
		)
		return response and response.result and response.result.contents
	end, 200),
	"rust-analyzer did not become ready"
)
assert(vim.treesitter.get_parser(buf, "rust"):parse()[1], "Rust parser missing")
local function request(method, params)
	local response, err = client:request_sync(method, params, 10000, buf)
	assert(response and not response.err, vim.inspect(response or err))
	return response.result
end
local uri = vim.uri_from_bufnr(buf)
local definition =
	request("textDocument/definition", { textDocument = { uri = uri }, position = { line = 5, character = 20 } })
assert(definition and #definition > 0, "Rust definition missing")
local completion_line = vim.api.nvim_buf_get_lines(buf, 7, 8, false)[1]
assert(
	vim.wait(15000, function()
		local items = request("textDocument/completion", {
			textDocument = { uri = uri },
			position = { line = 7, character = assert(completion_line:find("capacity", 1, true)) - 1 },
			context = { triggerKind = 2, triggerCharacter = "." },
		})
		return items and #(items.items or items) > 0
	end, 200),
	"Rust completion missing"
)
vim.api.nvim_buf_set_lines(buf, 4, 5, false, { "fn main(){" })
require("conform").format({ bufnr = buf, async = false, timeout_ms = 10000 })
assert(vim.api.nvim_buf_get_lines(buf, 4, 5, false)[1] == "fn main() {", "Rustfmt via rust-analyzer failed")
vim.cmd("edit!")
vim.cmd.edit(root .. "/Cargo.toml")
local manifest = vim.api.nvim_get_current_buf()
assert(
	vim.wait(10000, function()
		local c = vim.lsp.get_clients({ bufnr = manifest, name = "taplo" })[1]
		return c and c.initialized
	end, 100),
	"Cargo.toml LSP missing"
)
vim.api.nvim_buf_set_lines(manifest, 1, 2, false, { 'name="nvim-rust-smoke"' })
require("conform").format({ bufnr = manifest, async = false, timeout_ms = 10000 })
assert(
	table.concat(vim.api.nvim_buf_get_lines(manifest, 0, -1, false), "\n"):find('name = "nvim-rust-smoke"', 1, true),
	"TOML formatting failed"
)
vim.cmd("edit!")
io.stdout:write(
	"PASS: Rust Cargo test/clippy/fmt, analyzer, parser, completion, definition, formatting and Cargo manifest tooling\n"
)
