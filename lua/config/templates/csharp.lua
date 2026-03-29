local template_group = vim.api.nvim_create_augroup("FileTemplates", { clear = true })

local function to_pascal_case(str)
  str = str:gsub("%.cs$", "")
  str = str:gsub("_(%l)", function(c)
    return c:upper()
  end)
  str = str:gsub("^%l", string.upper)
  return str
end

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.cs",
  group = template_group,
  callback = function()
    local line_count = vim.api.nvim_buf_line_count(0)
    local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] or ""

    if line_count > 1 or first_line ~= "" then
      return
    end

    local filename = vim.fn.expand("%:t")
    local filepath = vim.fn.expand("%:p:h")
    local name_original = filename:gsub("%.cs$", "")

    local is_interface = name_original:match("^I(%u.+)") ~= nil
    local is_controller = name_original:match("Controllers?$") ~= nil
    local classname = to_pascal_case(filename)

    local namespace = filepath:match("[/\\]src[/\\](.+)$") or filepath:match("src[/\\](.+)$") or "App"
    namespace = namespace:gsub("/", "."):gsub("\\", ".")

    if namespace == "" or namespace == filepath then
      namespace = "App"
    end

    local template
    local cursor_line

    if is_controller then
      template = {
        "using Microsoft.AspNetCore.Mvc;",
        "",
        "namespace " .. namespace .. ";",
        "",
        '[Route("[controller]")]',
        "public class " .. classname .. " : ControllerBase",
        "{",
        "    ",
        "}",
      }
      cursor_line = 8
    else
      local type_keyword = is_interface and "interface" or "class"
      template = {
        "namespace " .. namespace .. ";",
        "",
        "public " .. type_keyword .. " " .. classname,
        "{",
        "    ",
        "}",
      }
      cursor_line = 5
    end

    vim.api.nvim_buf_set_lines(0, 0, -1, false, template)

    -- FIX: vim.schedule garante cursor no lugar certo
    vim.schedule(function()
      vim.api.nvim_win_set_cursor(0, { cursor_line, 4 })
      vim.cmd("startinsert")
    end)
  end,
})
