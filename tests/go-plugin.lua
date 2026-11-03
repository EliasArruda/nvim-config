local spec = dofile(vim.env.NVIM_TEST_ROOT .. "/lua/plugins/lang/go-nvim.lua")[1]
assert(spec.build == nil, "Go tools must not be bulk-updated by the plugin build")
require("lazy").load({ plugins = { "go.nvim" } })
assert(require("lazy.core.config").plugins["go.nvim"]._.loaded, "go.nvim did not load")
for _, mapping in ipairs(spec.keys) do
	local command = assert(mapping[2]:match("<cmd>(%w+)"), "Unrecognized Go mapping")
	assert(vim.fn.exists(":" .. command) == 2, "Missing mapped Go command: " .. command)
end

print("PASS: go.nvim loads and all seven mapped commands exist without a shell build hook")
