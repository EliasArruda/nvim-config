vim.api.nvim_create_autocmd("FileType", {
  pattern = "http",
  callback = function()
    -- Impede que plugins de autoformat mexam neste buffer
    vim.b.autoformat = false

    -- Configurações de tab específicas
    vim.opt_local.expandtab = false
    vim.opt_local.shiftwidth = 0
    vim.opt_local.tabstop = 2
  end,
})

-- Calculo
vim.keymap.set("n", "<leader>fa", function()
  vim.ui.input({ prompt = "Calc: " }, function(expr)
    if not expr or expr == "" then
      return
    end

    local ok, result = pcall(function()
      return load("return " .. expr)()
    end)

    if ok then
      result = tostring(result)

      vim.fn.setreg('"', result)
      vim.fn.setreg("0", result)
      vim.fn.setreg("+", result)

      vim.notify("Resultado: " .. result)
    else
      vim.notify("Erro na expressão", vim.log.levels.ERROR)
    end
  end)
end)

-- Numbers remove
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
  end,
})
