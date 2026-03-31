return {
  {
    "tpope/vim-dadbod",
    dependencies = {
      "kristijanhusak/vim-dadbod-ui",
    },
    config = function()
      -- Atalho para abrir a interface
      vim.keymap.set("n", "<leader>db", ":DBUIToggle<CR>", { noremap = true, silent = true })

      -- Conexão com seu banco no Docker
      vim.g.dbs = {
        pixelqueue_dev = "postgresql://pixelqueue_user:pixelqueue_123@localhost:5432/pixelqueue",
      }

      -- Configurações visuais da UI (opcional)
      vim.g.db_ui_show_database_navigation = 1
      vim.g.db_ui_save_queries_state = 1
    end,
  },
}
