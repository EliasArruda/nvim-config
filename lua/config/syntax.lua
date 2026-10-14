local M = {}

-- Cyberdream default palette: https://github.com/scottmckendry/cyberdream.nvim
function M.apply()
	local colors = {
		["#7b8496"] = { "Comment", "@comment" },
		["#5eff6c"] = { "String", "Character", "@string", "@character" },
		["#ffbd5e"] = { "Number", "Float", "Keyword", "Label", "Debug", "@number", "@tag", "@keyword.type" },
		["#ff5ef1"] = { "Statement", "Conditional", "Repeat", "Exception", "StorageClass", "@module" },
		["#5ea1ff"] = { "Function", "@function", "@function.builtin", "@function.method" },
		["#5ef1ff"] = { "Boolean", "PreProc", "Include", "Define", "Macro", "PreCondit", "@boolean" },
		["#bd5eff"] = { "Type", "Typedef", "Structure", "Operator", "@type", "@operator" },
		["#ff5ea0"] = { "Constant", "Special", "SpecialChar", "SpecialComment", "@constant", "@variable.builtin" },
		["#cb5ecd"] = { "@type.builtin" },
		["#ffffff"] = { "Identifier", "Delimiter", "@variable", "@property", "@variable.parameter", "@tag.attribute", "@tag.delimiter", "@punctuation.bracket", "@punctuation.delimiter", "@punctuation.special" },
	}
	for color, groups in pairs(colors) do
		for _, name in ipairs(groups) do
			vim.api.nvim_set_hl(0, name, { fg = color })
		end
	end
	local links = {
		["@keyword"] = "Keyword",
		["@keyword.function"] = "Keyword",
		["@keyword.return"] = "Keyword",
		["@keyword.conditional"] = "Conditional",
		["@keyword.repeat"] = "Repeat",
		["@keyword.exception"] = "Exception",
		["@keyword.modifier"] = "StorageClass",
		["@keyword.import"] = "Include",
		["@keyword.operator"] = "Operator",
		["@string.escape"] = "SpecialChar",
		["@string.documentation"] = "Comment",
		["@tag.html"] = "@tag",
		["@tag.razor"] = "@tag",
		["@tag.attribute.html"] = "@tag.attribute",
		["@tag.delimiter.html"] = "@tag.delimiter",
		["@lsp.type.class.razor"] = "@type",
	}
	local semantic = {
		class = "@type", struct = "@type", interface = "@type", enum = "@type",
		type = "@type", typeParameter = "@type", namespace = "@module",
		function_ = "@function", method = "@function.method", macro = "Macro",
		variable = "@variable", parameter = "@variable.parameter", property = "@property",
		enumMember = "@constant", event = "@property", keyword = "@keyword",
		comment = "@comment", string = "@string", number = "@number", operator = "@operator",
	}
	for token, target in pairs(semantic) do
		links["@lsp.type." .. (token == "function_" and "function" or token)] = target
	end
	for name, target in pairs(links) do
		vim.api.nvim_set_hl(0, name, { link = target })
	end
end

return M
