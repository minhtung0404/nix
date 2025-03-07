local icons = require("icons")

local timer = sbar.add("item", "timer", {
	position = "right",
	icon = {
		string = icons.loading,
		padding_left = 0,
		padding_right = 0,
	},
	label = {
		padding_left = 0,
		padding_right = 0,
	},
	background = {
		padding_left = 0,
		padding_right = 0,
	},
	popup = {
		drawing = false,
	},
})

local function reset_timer()
	timer:set({ popup = { drawing = "toggle" } })
	sbar.exec("${CONFIG_DIR}/plugins/reset_timer.sh")
end

local Timer = {}
Timer.__index = Timer

function Timer:new(name, label, count_down)
	count_down = count_down or ""
	local new_timer = {
		item = sbar.add("item", timer.name .. "." .. name, {
			position = "popup." .. timer.name,
			label = label,
		}),
	}

	new_timer.item:subscribe("mouse.clicked", function(_)
		timer:set({ popup = { drawing = "toggle" } })
		sbar.exec("python3 ${CONFIG_DIR}/plugins/timer.py " .. count_down)
	end)

	setmetatable(new_timer, self)

	return new_timer
end

local timer_stopwatch = Timer:new("stopwatch", "SW Mode")
local preset1 = Timer:new("preset1", "3 mins", 180)
local preset2 = Timer:new("preset2", "5 mins", 300)
local preset3 = Timer:new("preset3", "10 mins", 600)
local preset4 = Timer:new("preset4", "1 hour", 3600)

timer:subscribe("mouse.clicked", function(_)
	reset_timer()
end)

timer:subscribe("mouse.exited.global", function(_)
	reset_timer()
	timer:set({ popup = { drawing = false } })
end)
