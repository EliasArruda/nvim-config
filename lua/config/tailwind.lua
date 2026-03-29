require("lspconfig").tailwindcss.setup({
  settings = {
    tailwindCSS = {
      experimental = {
        -- Aqui você adiciona o regex para CVA e cn
        classRegex = {
          { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
          { "cn\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
        },
      },
    },
  },
})
