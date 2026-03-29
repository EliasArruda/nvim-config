return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      ts_ls = {},
      volar = {},
      eslint = {},
      dockerls = {},
      jsonls = {},
      html = {},
      cssls = {},
      yamlls = { settings = { yaml = { validate = true } } },
      ruff = {
        on_attach = function(client, _)
          client.server_capabilities.hoverProvider = false
        end,
      },
      pyright = {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
      },
    },
  },
}
