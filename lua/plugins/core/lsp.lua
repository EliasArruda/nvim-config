vim.lsp.enable("roslyn_ls")
return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      ts_ls = {
        filetypes = {
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "vue",
        },
        init_options = {
          plugins = {
            {
              name = "@vue/typescript-plugin",
              location = vim.fn.stdpath("data")
                .. "/mason/packages/vue-language-server/node_modules/@vue/language-plugin",
              languages = { "vue" },
            },
          },
        },
      },
      volar = {
        filetypes = { "vue" },
        init_options = {
          vue = {
            hybridMode = true,
          },
        },
      },
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
