require("config.lazy")
require("config.autocmds")
require("config.nvim-dap")
require("config.nvim-dap-ui")
require("config.highlights")
require("config.templates.csharp")
require("config.templates.react")
require("config.tailwind")
require("neotest").setup({
  adapters = {
    require("neotest-dotnet"),
  },
})
