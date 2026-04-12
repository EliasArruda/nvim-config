return {
  "stevearc/conform.nvim",
  opts = {
    async = true,

    formatters_by_ft = {
      cs = { "csharpier" },
      css = { "prettier" },
      html = { "prettier" },
      csproj = { "xmlformat" },
      xml = { "xmlformat" },
      caddy = { "caddy" },

      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      vue = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      yml = { "prettier" },
    },

    formatters = {
      xmlformat = {
        command = "xmlformat",
      },

      csharpier = {
        command = "csharpier",
        args = { "format", "--write-stdout" },
        stdin = true,
      },

      caddy = {
        command = "caddy",
        args = { "fmt", "-" },
        stdin = true,
      },
    },
  },
}
