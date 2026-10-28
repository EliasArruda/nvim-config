return function(mode)
	for _, picker in ipairs(Snacks.picker.get({ source = "select" })) do
		for index, item in ipairs(picker:items()) do
			local label = item.text:lower()
			local wanted = mode == "test" and "test" or mode == "debug" and "build" or "run"
			if label:find(wanted, 1, true) and (mode == "test" or not label:find("test", 1, true)) then
				picker.list:move(index, true)
				picker:action("confirm")
				return
			end
		end
	end
end
