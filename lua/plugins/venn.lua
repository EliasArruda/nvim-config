return {
  "jbyuki/venn.nvim",
  config = function()
    -- Permite que o cursor se mova livremente no buffer
    vim.o.virtualedit = "all"

    -- Função para ativar/desativar keymaps do venn.nvim com mensagem
    function _G.Toggle_venn()
      local venn_enabled = vim.b.venn_enabled

      if not venn_enabled then
        -- Ativa o modo venn
        vim.b.venn_enabled = true
        print("Venn mode ativado!") -- mensagem ao ativar
        vim.cmd([[setlocal virtualedit=all]]) -- cursor livre

        -- Desenha linhas ao usar H/J/K/L
        vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", { noremap = true, silent = true })

        -- Desenha uma box com seleção visual + tecla "f"
        vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", { noremap = true, silent = true })
      else
        -- Desativa o modo venn
        vim.b.venn_enabled = nil
        print("Venn mode desativado!") -- mensagem ao desativar
        vim.cmd([[setlocal virtualedit=]])
        vim.api.nvim_buf_del_keymap(0, "n", "J")
        vim.api.nvim_buf_del_keymap(0, "n", "K")
        vim.api.nvim_buf_del_keymap(0, "n", "L")
        vim.api.nvim_buf_del_keymap(0, "n", "H")
        vim.api.nvim_buf_del_keymap(0, "v", "f")
      end
    end

    -- Atalho global para ativar/desativar venn.nvim
    -- Pressione <leader>v no modo normal
    vim.api.nvim_set_keymap("n", "<leader>v", ":lua Toggle_venn()<CR>", { noremap = true, silent = true })
  end,
}
