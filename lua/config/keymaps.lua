local Snacks = require("snacks")

-- Rastreia quais terminais estão visíveis (por índice)
-- 👇 A MUDANÇA ESTÁ AQUI: { "n", "t", "i" }
vim.keymap.set({ "n", "t", "i" }, "<C-t>", function()
  -- 1. Verifica se os terminais existem na memória
  local t1 = Snacks.terminal.get(nil, { count = 1, create = false })
  local t2 = Snacks.terminal.get(nil, { count = 2, create = false })

  local t1_is_visible = t1 and t1.win and vim.api.nvim_win_is_valid(t1.win)
  local t2_is_visible = t2 and t2.win and vim.api.nvim_win_is_valid(t2.win)

  if t1_is_visible or t2_is_visible then
    -- 👇 SE ESTIVER ABERTO, ELE FECHA OS DOIS AQUI
    if t1_is_visible then
      t1:hide()
    end
    if t2_is_visible then
      t2:hide()
    end
  else
    -- SE ESTIVER FECHADO, ABRE OS DOIS
    local opts1 = { count = 1, win = { position = "bottom" }, interactive = false }
    Snacks.terminal.get(nil, opts1):show()

    vim.schedule(function()
      local opts2 = { count = 2, win = { position = "bottom" } }
      Snacks.terminal.get(nil, opts2):show()
    end)
  end
end, { desc = "Toggle 2 Terminais no Bottom" })
-- END

-- SALVAR
vim.keymap.set("i", "<C-s>", "<Esc><Cmd>update<CR>", { desc = "Salvar do insert", silent = true })

-- Code Actions (igual Ctrl+.)
vim.keymap.set({ "n", "i" }, "<C-.>", vim.lsp.buf.code_action, {
  desc = "Code Actions",
})

-- Go to definition
vim.keymap.set("n", "<C-CR>", vim.lsp.buf.definition, {
  desc = "Go to definition",
})

-- Alternativa confiável
vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
  desc = "Go to definition",
})

-- Fechar buffer instantaneamente, sem confirmação
vim.keymap.set("n", "<C-x>", function()
  vim.api.nvim_buf_delete(0, { force = true })
end, { desc = "Fechar buffer instantâneo" })

-- Copia o diagnostic da linha atual para o clipboard
vim.keymap.set("n", "<leader>cy", function()
  local diags = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
  if #diags > 0 then
    vim.fn.setreg("+", diags[1].message)
    print("Copied diagnostic: " .. diags[1].message)
  end
end, { desc = "Copy diagnostic to clipboard" })

-- URL
vim.keymap.set("n", "<leader>gx", function()
  local buf = vim.api.nvim_get_current_buf()

  -- pega últimas linhas do terminal
  local lines = vim.api.nvim_buf_get_lines(buf, -100, -1, false)

  for _, line in ipairs(lines) do
    local url = line:match("(https?://[%w%-%._~:/%?#%[%]@!$&'()*+,;=]+)")

    if url then
      vim.fn.jobstart({ "xdg-open", url }, { detach = true })
      print("Abrindo: " .. url)
      return
    end
  end

  print("Nenhuma URL encontrada (terminal)")
end)
