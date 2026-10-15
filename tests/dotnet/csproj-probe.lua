vim.cmd.cd(vim.env.NVIM_DOTNET_TEST_ROOT .. "/BlazorSmoke")
vim.cmd.edit("BlazorSmoke.csproj")
local r = { ft = vim.bo.filetype, loaded = require("lazy.core.config").plugins["easy-dotnet.nvim"]._.loaded ~= nil }
r.attached = vim.wait(25000, function()
	return #vim.lsp.get_clients({ bufnr = 0, name = "easy_dotnet_projx" }) > 0
end, 100)
r.razor_dap = type(require("dap").configurations.razor) == "table"
r.messages = vim.api.nvim_exec2("messages", { output = true }).output
vim.fn.writefile({ vim.json.encode(r) }, vim.env.NVIM_DOTNET_TEST_OUTPUT .. "/csproj.json")

assert(r.ft == "xml" and r.loaded and r.attached and r.razor_dap, "ProjX/Razor DAP bootstrap failed")
