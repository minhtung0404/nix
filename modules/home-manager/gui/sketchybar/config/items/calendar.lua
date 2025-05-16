local settings = require("settings")
local colors = require("colors")

local cal = sbar.add("item", "calendar", {
	icon = {
		color = colors.black,
		padding_left = 8,
		font = {
			style = settings.font.style_map["Black"],
			size = 12.0,
		},
	},
	label = {
		color = colors.black,
		padding_right = 8,
		width = 49,
		align = "right",
		font = { family = settings.font.numbers },
	},
	position = "center",
	update_freq = 30,
	padding_left = 1,
	padding_right = 1,
	background = {
		color = colors.green,
		border_color = colors.green,
		border_width = 1,
	},
})

cal:subscribe({ "forced", "routine", "system_woke" }, function(env)
	cal:set({ icon = os.date("%a. %d %b."), label = os.date("%H:%M") })
end)
