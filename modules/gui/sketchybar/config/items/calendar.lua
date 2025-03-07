local settings = require("settings")
local colors = require("colors")

-- Padding item required because of bracket
-- sbar.add("item", { position = "center", width = settings.group_paddings })

local cal = sbar.add("item", {
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

-- Double border for calendar using a single item bracket
sbar.add("bracket", { cal.name }, {
	background = {
		color = colors.transparent,
		height = settings.calendar_background_height or 30,
		border_color = colors.grey,
	},
})

-- Padding item required because of bracket
-- sbar.add("item", { position = "center", width = settings.group_paddings })

cal:subscribe({ "forced", "routine", "system_woke" }, function(env)
	cal:set({ icon = os.date("%a. %d %b."), label = os.date("%H:%M") })
end)
