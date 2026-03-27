return {
  {
    "NvChad/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        "*", -- aplica para todos os arquivos
        css = { rgb_fn = true }, -- habilita funções rgb() no CSS
        html = { names = true }, -- nomes de cores em HTML
      }, {
        mode = "foreground", -- ou "background", dependendo do que você quer
      })
    end,
  },
}
