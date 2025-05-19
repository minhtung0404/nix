local icons = require("icons")
local colors = require("colors")
local cmd = require("helpers.cmd")

local media_cover = sbar.add("item", "widgets.media.cover", {
	position = "right",
	background = {
		image = {
			string = "./images/amira_squared.jpeg",
			scale = 0.04,
		},
		color = colors.transparent,
	},
	label = { drawing = false },
	icon = { drawing = false },
	drawing = true,
	updates = true,
	popup = {
		align = "center",
		horizontal = true,
	},
	update_freq = 5,
})
