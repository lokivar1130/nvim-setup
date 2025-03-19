local M = {}
M.get_foundry_remappings = function()
	local foundry_toml = vim.fn.getcwd() .. "/foundry.toml"
	local remappings = {}

	local file = io.open(foundry_toml, "r")
	if not file then
		return remappings
	end

	local content = file:read("*all") -- Read entire file
	file:close()

	-- Find the `remappings = [...]` block
	local remappings_block = content:match("remappings%s*=%s*%[([^%]]+)%]") -- Capture inside `[...]`
	if not remappings_block then
		return remappings
	end

	-- Extract individual remappings (split by comma)
	for remap in remappings_block:gmatch('"(.-)"') do -- Capture quoted strings
		local key, value = remap:match("([^=]+)=(.+)")
		if key and value then
			table.insert(remappings, key .. "=" .. vim.fn.getcwd() .. "/" .. value)
		end
	end

	return remappings
end
return M
