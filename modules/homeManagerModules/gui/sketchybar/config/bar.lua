local colors = require("colors")
local settings = require("settings")

-- Equivalent to the --bar domain
sbar.bar({
	topmost = "window",
	height = settings.bar_height or 40,
	color = colors.bar.bg,
	padding_right = 2,
	padding_left = 2,
})
