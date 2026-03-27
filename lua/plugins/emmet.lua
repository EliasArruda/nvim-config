return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      emmet_language_server = {
        init_options = {
          includeLanguages = {
            javascript = "javascriptreact",
            typescript = "typescriptreact",
          },
        },
      },
    },
  },
}
