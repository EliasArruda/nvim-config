-- ============================================
-- REACT TEMPLATE GROUP
-- ============================================
local react_group = vim.api.nvim_create_augroup("ReactTemplates", { clear = true })

-- Função auxiliar: PascalCase
local function to_pascal_case(str)
  str = str:gsub("%.tsx$", ""):gsub("%.jsx$", "")
  str = str:gsub("_(%l)", function(c)
    return c:upper()
  end)
  str = str:gsub("^%l", string.upper)
  return str
end

-- ============================================
-- REACT TSX (TypeScript)
-- ============================================
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.tsx",
  group = react_group,
  callback = function()
    local line_count = vim.api.nvim_buf_line_count(0)
    local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] or ""

    if line_count > 1 or first_line ~= "" then
      return
    end

    local filename = vim.fn.expand("%:t")
    local component_name = to_pascal_case(filename)

    -- Template TSX: 11 linhas, cursor na linha 8 (dentro da div)
    local template = {
      "interface " .. component_name .. "Props {", -- 1
      "  ", -- 2
      "}", -- 3
      "", -- 4
      "export function " .. component_name .. "({}: " .. component_name .. "Props) {", -- 5
      "  return (", -- 6
      "    <div>", -- 7
      "      ", -- 8 <-- CURSOR AQUI
      "    </div>", -- 9
      "  );", -- 10
      "}", -- 11
    }

    vim.api.nvim_buf_set_lines(0, 0, -1, false, template)

    -- Cursor: linha 8 (dentro da div), coluna 6 (após os 6 espaços de indentação)
    vim.schedule(function()
      vim.api.nvim_win_set_cursor(0, { 8, 6 })
      vim.cmd("startinsert")
    end)
  end,
})

-- ============================================
-- REACT JSX (JavaScript)
-- ============================================
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.jsx",
  group = react_group,
  callback = function()
    local line_count = vim.api.nvim_buf_line_count(0)
    local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] or ""

    if line_count > 1 or first_line ~= "" then
      return
    end

    local filename = vim.fn.expand("%:t")
    local component_name = to_pascal_case(filename)

    -- Template JSX: 7 linhas, cursor na linha 4 (dentro da div)
    local template = {
      "export function " .. component_name .. "() {", -- 1
      "  return (", -- 2
      "    <div>", -- 3
      "      ", -- 4 <-- CURSOR AQUI
      "    </div>", -- 5
      "  );", -- 6
      "}", -- 7
    }

    vim.api.nvim_buf_set_lines(0, 0, -1, false, template)

    -- Cursor: linha 4 (dentro da div), coluna 6
    vim.schedule(function()
      vim.api.nvim_win_set_cursor(0, { 4, 6 })
      vim.cmd("startinsert")
    end)
  end,
})
