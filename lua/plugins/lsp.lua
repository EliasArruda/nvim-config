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
    },
  },
}
