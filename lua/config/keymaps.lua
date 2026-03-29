local Snacks = require("snacks")

-- Rastreia quais terminais estão visíveis (por índice)
local visible = {}

local function toggle_all_terminals()
  local terminals = Snacks.terminal.list()

  if #terminals == 0 then
    Snacks.terminal.toggle(nil, { direction = "horizontal" })
    visible[1] = true
    return
  end

  local any_visible = false
  for i, _ in ipairs(terminals) do
    if visible[i] then
      any_visible = true
      break
    end
  end

  if any_visible then
    -- Esconder todos
    for i, term in ipairs(terminals) do
      if visible[i] then
        term:toggle()
        visible[i] = false
      end
    end
  else
    -- Reabrir todos
    for i, term in ipairs(terminals) do
      if not visible[i] then
        term:toggle()
        visible[i] = true
      end
    end
  end
end

vim.keymap.set("n", "<C-t>", toggle_all_terminals, {
  desc = "Toggle todos os terminais",
})
-- END

-- SALVAR
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>", { desc = "Salvar e sair do insert", silent = true, noremap = true })

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
