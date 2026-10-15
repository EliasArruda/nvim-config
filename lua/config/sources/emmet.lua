local Source = {}
Source.__index = Source

function Source.new()
	return setmetatable({}, Source)
end
function Source:enabled()
	return vim.bo.filetype == "razor" and not require("config.runtime").is_large(0)
end
function Source:get_trigger_characters()
	return vim.split("abcdefghijklmnopqrstuvwxyz0123456789.:>+^*)]}@/", "")
end
function Source:get_completions(ctx, callback)
	local empty = { items = {}, is_incomplete_forward = true, is_incomplete_backward = true }
	if require("configs.langs.razor").is_code_or_comment(ctx.bufnr, ctx.cursor) then
		callback(empty)
		return
	end
	local client = vim.lsp.get_clients({ name = "emmet_language_server", bufnr = ctx.bufnr })[1]
	if not client or not client.initialized then
		callback(empty)
		return
	end
	local line = vim.api.nvim_buf_get_lines(ctx.bufnr, ctx.cursor[1] - 1, ctx.cursor[1], false)[1] or ""
	local params = {
		textDocument = { uri = vim.uri_from_bufnr(ctx.bufnr) },
		position = {
			line = ctx.cursor[1] - 1,
			character = vim.str_utfindex(line, client.offset_encoding, ctx.cursor[2], false),
		},
		context = { triggerKind = 1 },
	}
	local active = true
	local ok, request = client:request("textDocument/completion", params, function(err, result)
		if not active then
			return
		end
		active = false
		if err or not result then
			callback(empty)
			return
		end
		local items = result.items or result
		for _, item in ipairs(items) do
			item.client_id, item.client_name, item.cursor_column = client.id, client.name, ctx.cursor[2]
			local defaults = result.itemDefaults or {}
			for _, key in ipairs({ "commitCharacters", "insertTextFormat", "insertTextMode", "data" }) do
				if item[key] == nil then
					item[key] = defaults[key]
				end
			end
			if defaults.editRange and not item.textEdit then
				local text = item.textEditText or item.insertText or item.label
				item.textEdit = defaults.editRange.replace
						and { insert = defaults.editRange.insert, replace = defaults.editRange.replace, newText = text }
					or { range = defaults.editRange, newText = text }
			end
		end
		callback({ items = items, is_incomplete_forward = result.isIncomplete or false, is_incomplete_backward = true })
	end, ctx.bufnr)
	if not ok then
		active = false
		callback(empty)
	end
	return function()
		active = false
		if request then
			client:cancel_request(request)
		end
	end
end

function Source:resolve(item, callback)
	return require("blink.cmp.sources.lsp").resolve(self, item, callback)
end

return Source
