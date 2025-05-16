local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

local apple = sbar.add("item", "apple", {
	icon = {
		font = { size = 16.0 },
		string = icons.apple,
		padding_right = 8,
		padding_left = 8,
    color = colors.black,
	},
	label = { 
    drawing = false 
  },
	background = {
		color = colors.red,
		border_color = colors.black,
		border_width = 1,
	},
	padding_left = 6,
	padding_right = 8,
	click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s 0",
})
