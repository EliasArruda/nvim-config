local template_group = vim.api.nvim_create_augroup("VueFileTemplates", { clear = true })

-- Converte file-name para PascalCase (ex: my-component.vue -> MyComponent)
local function to_pascal_case(str)
	str = str:gsub("%.vue$", "")
	-- Trata hifens e underscores
	str = str:gsub("[%-_](%l)", function(c)
		return c:upper()
	end)
	str = str:gsub("^%l", string.upper)
	return str
end

local function is_buffer_empty()
	local line_count = vim.api.nvim_buf_line_count(0)
	if line_count > 1 then
		return false
	end
	local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] or ""
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
	local delay = vim.g.vscode and 200 or 0

	vim.defer_fn(function()
		local filename = vim.fn.expand("%:t")
		local filepath = vim.fn.expand("%:p:h")

		if filename == "" or not filename:match("%.vue$") then
			return
		end
		if not is_buffer_empty() then
			return
		end

		local component_name = to_pascal_case(filename)

		-- Detecta o tipo baseado na pasta (pages, layouts, components)
		local is_page = filepath:match("[/\\]pages") or filepath:match("[/\\]views")
		local is_layout = filepath:match("[/\\]layouts")

		local template = {}
		local cursor_line = 2
		local cursor_col = 0

		if is_layout then
			-- Template para Layouts (com slot)
			template = {
				'<script setup lang="ts">',
				"",
				"</script>",
				"",
				"<template>",
				'  <div class="layout-' .. component_name:lower() .. '">',
				"    <header>",
				"      <!-- Header content -->",
				"    </header>",
				"    <main>",
				"      <slot />",
				"    </main>",
				"  </div>",
				"</template>",
				"",
				"<style scoped>",
				"",
				"</style>",
			}
			cursor_line = 2
		elseif is_page then
			-- Template para Pages (geralmente com Head/Meta se usar Nuxt ou similar)
			template = {
				'<script setup lang="ts">',
				"definePageMeta({",
				'  layout: "default"',
				"})",
				"",
				"</script>",
				"",
				"<template>",
				"  <div>",
				"    <h1>" .. component_name .. " Page</h1>",
				"  </div>",
				"</template>",
				"",
				"<style scoped>",
				"",
				"</style>",
			}
			cursor_line = 5
		else
			-- Template para Componentes padrão (SFC - Script Setup)
			template = {
				'<script setup lang="ts">',
				"interface Props {",
				"  modelValue?: string",
				"}",
				"",
				"const props = defineProps<Props>()",
				'const emit = defineEmits(["update:modelValue"])',
				"",
				"</script>",
				"",
				"<template>",
				'  <div class="' .. component_name:lower() .. '">',
				"    ",
				"  </div>",
				"</template>",
				"",
				"<style scoped>",
				"",
				"</style>",
			}
			cursor_line = 13
			cursor_col = 4
		end

		apply_template(template, cursor_line, cursor_col)
	end, delay)
end

vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost", "BufEnter" }, {
	pattern = "*.vue",
	group = template_group,
	callback = run_template,
})
