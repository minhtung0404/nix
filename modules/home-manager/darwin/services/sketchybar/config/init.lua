-- Require the sketchybar module
sbar = require("sketchybar")

function sbar.exec_lua(command, callback)
	local handle = io.popen(command)
	if handle == nil then
		return
	end

	local result = handle:read("*a")
	if type(callback) == "function" then
		callback(result)
	end
	handle:close()
end

-- Set the bar name, if you are using another bar instance than sketchybar
-- sbar.set_bar_name("bottom_bar")

-- Bundle the entire initial configuration into a single message to sketchybar
sbar.begin_config()
require("bar")
require("default")
require("items")
print("DEBUG")
sbar.end_config()

-- Run the event loop of the sketchybar module (without this there will be no
-- callback functions executed in the lua module)
sbar.event_loop()
