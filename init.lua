require("config.lazy")
require("config.autocmds")
require("config.nvim-dap")
require("config.nvim-dap-ui")
require("config.highlights")
require("neotest").setup({
  adapters = {
    require("neotest-dotnet"),
  },
})
