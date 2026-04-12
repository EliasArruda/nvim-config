local razor_group = vim.api.nvim_create_augroup("RazorIndentation", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "razor", "cshtml" },
  group = razor_group,
  callback = function()
    local opts = { buffer = true, silent = true }

    -- 1. Configurações de indentação (Buffer-local)
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.expandtab = true
    vim.opt_local.smartindent = true

    -- 2. Mapeamento performático para o Enter
    vim.keymap.set("i", "<CR>", function()
      -- Pegamos a linha e a coluna de forma eficiente
      local line = vim.api.nvim_get_current_line()
      local col = vim.api.nvim_win_get_cursor(0)[2]

      -- Verifica se o cursor está exatamente entre '>' e '<'
      -- Em Lua, strings são base 1. col é a posição do cursor (base 0).
      if col > 0 and line:sub(col, col) == ">" and line:sub(col + 1, col + 1) == "<" then
        -- <CR> desce a tag de fechamento
        -- <C-f> força o re-alinhamento (útil em alguns filetypes)
        -- <C-o>O abre a linha no meio com a indentação correta
        return "<CR><C-o>O"
      end

      -- Se não estiver entre tags, retorna o Enter normal
      return "<CR>"
    end, { expr = true, buffer = true, desc = "Expandir Tag Razor" })
  end,
})
