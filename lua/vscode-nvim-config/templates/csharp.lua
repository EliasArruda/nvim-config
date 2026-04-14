local template_group = vim.api.nvim_create_augroup("FileTemplates", { clear = true })

local function to_pascal_case(str)
  str = str:gsub("%.cs$", "")
  str = str:gsub("_(%l)", function(c)
    return c:upper()
  end)
  str = str:gsub("^%l", string.upper)
  return str
end

local function get_dotnet_namespace(directory)
  local current_dir = directory
  local sub_namespaces = {}
  local project_name = nil

  for _ = 1, 10 do
    local search_path = vim.fn.fnameescape(current_dir) .. "/*.csproj"
    local csproj_files = vim.fn.glob(search_path, true, true)

    if #csproj_files > 0 then
      project_name = vim.fn.fnamemodify(csproj_files[1], ":t:r")
      break
    end

    local folder_name = vim.fn.fnamemodify(current_dir, ":t")
    table.insert(sub_namespaces, 1, folder_name)

    local parent_dir = vim.fn.fnamemodify(current_dir, ":h")
    if parent_dir == current_dir then
      break
    end
    current_dir = parent_dir
  end

  if project_name then
    local full_namespace = project_name
    if #sub_namespaces > 0 then
      full_namespace = full_namespace .. "." .. table.concat(sub_namespaces, ".")
    end
    return full_namespace:gsub("[^%w%.]", "_")
  end

  local fallback = directory:match("[/\\]src[/\\](.+)$") or directory:match("src[/\\](.+)$") or "App"
  return fallback:gsub("[/\\]", "."):gsub("[^%w%.]", "_")
end

local function is_buffer_empty()
  local line_count = vim.api.nvim_buf_line_count(0)
  if line_count > 1 then
    return false
  end
  local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] or ""
  -- Considera vazio mesmo se tiver só espaços/newlines (VS Code às vezes injeta isso)
  return first_line:match("^%s*$") ~= nil
end

local function apply_template(template, cursor_line, cursor_col)
  vim.api.nvim_buf_set_lines(0, 0, -1, false, template)

  vim.defer_fn(function()
    local line_count = vim.api.nvim_buf_line_count(0)
    local safe_line = math.min(cursor_line, line_count)
    vim.api.nvim_win_set_cursor(0, { safe_line, cursor_col })
    if vim.g.vscode then
      vim.cmd("startinsert!")
    else
      vim.cmd("startinsert")
    end
  end, vim.g.vscode and 150 or 0)
end

local function run_template()
  -- Aguarda o VS Code associar o path ao buffer antes de checar
  local delay = vim.g.vscode and 200 or 0

  vim.defer_fn(function()
    local filename = vim.fn.expand("%:t")
    local filepath = vim.fn.expand("%:p:h")

    if filename == "" or not filename:match("%.cs$") then
      return
    end
    if not is_buffer_empty() then
      return
    end

    local classname = to_pascal_case(filename)

    local is_interface = classname:match("^I%u") ~= nil
    local is_controller = classname:match("Controller$") ~= nil
    local is_exception = classname:match("Exception$") ~= nil
    local is_test = classname:match("Tests?$") ~= nil
    local is_record = classname:match("Dto$")
      or classname:match("Command$")
      or classname:match("Query$")
      or classname:match("Event$")
      or classname:match("Request$")
      or classname:match("Response$")

    local namespace = get_dotnet_namespace(filepath)
    local template, cursor_line
    local cursor_col = 4

    if classname == "GlobalUsings" then
      template = {
        "global using System;",
        "global using System.Collections.Generic;",
        "global using System.Linq;",
        "global using System.Threading.Tasks;",
        "",
      }
      cursor_line = 5
      cursor_col = 0
    elseif is_controller then
      template = {
        "using Microsoft.AspNetCore.Mvc;",
        "",
        "namespace " .. namespace .. ";",
        "",
        "[ApiController]",
        '[Route("[controller]")]',
        "public class " .. classname .. " : ControllerBase",
        "{",
        "    ",
        "}",
      }
      cursor_line = 9
    elseif is_test then
      template = {
        "using Xunit;",
        "using FluentAssertions;",
        "",
        "namespace " .. namespace .. ";",
        "",
        "public class " .. classname,
        "{",
        "    [Fact]",
        "    public void Should_",
        "    {",
        "        // Arrange",
        "        ",
        "        // Act",
        "        ",
        "        // Assert",
        "        ",
        "    }",
        "}",
      }
      cursor_line = 9
      cursor_col = 23
    elseif is_exception then
      template = {
        "namespace " .. namespace .. ";",
        "",
        "public class " .. classname .. " : Exception",
        "{",
        "    public " .. classname .. "(string message) : base(message)",
        "    {",
        "        ",
        "    }",
        "}",
      }
      cursor_line = 7
    elseif is_record then
      template = {
        "namespace " .. namespace .. ";",
        "",
        "public record " .. classname,
        "{",
        "    ",
        "}",
      }
      cursor_line = 5
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

    apply_template(template, cursor_line, cursor_col)
  end, delay)
end

vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost", "BufEnter" }, {
  pattern = "*.cs",
  group = template_group,
  callback = run_template,
})
