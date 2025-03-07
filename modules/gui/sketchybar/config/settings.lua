return {
	paddings = 3,
	group_paddings = 5,

	icons = "NerdFont", -- alternatively available: NerdFont
	bar_height = 24,
	icon_size = 13.0,
	label_size = 12.0,
	background_height = 22,
	apple_background_height = 23,
	calendar_background_height = 23,
	spaces_background_height = 23,

	-- This is a font configuration for SF Pro and SF Mono (installed manually)
	-- font = require("helpers.default_font"),

	-- Alternatively, this is a font config for JetBrainsMono Nerd Font
	font = {
		text = "FiraCode Nerd Font", -- Used for text
		numbers = "FiraCode Nerd Font", -- Used for numbers
		style_map = {
			["Regular"] = "Regular",
			["Semibold"] = "Retina",
			["Bold"] = "Medium",
			["Heavy"] = "Semibold",
			["Black"] = "Bold",
		},
	},
}
