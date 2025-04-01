local function cmd(command, callback)
	local handle = io.popen(command)
	local result = handle:read("*a")
	callback(result)
end

return cmd
