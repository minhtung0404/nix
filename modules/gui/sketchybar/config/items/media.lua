local icons = require("icons")
local colors = require("colors")
local cmd = require("helpers.cmd")

local whitelist = { ["Spotify"] = true, ["Music"] = true }

local media_cover = sbar.add("item", {
	position = "right",
	background = {
		image = {
			string = "~/Pictures/amira_squared.jpeg",
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

local media_artist = sbar.add("item", {
	position = "right",
	drawing = false,
	padding_left = 3,
	padding_right = 0,
	width = 0,
	icon = { drawing = false },
	label = {
		width = 0,
		font = { size = 9 },
		color = colors.with_alpha(colors.white, 0.6),
		max_chars = 18,
		y_offset = 6,
	},
})

local media_title = sbar.add("item", {
	position = "right",
	drawing = false,
	padding_left = 3,
	padding_right = 0,
	icon = { drawing = false },
	label = {
		font = { size = 11 },
		width = 0,
		max_chars = 16,
		y_offset = -5,
	},
})

sbar.add("item", {
	position = "popup." .. media_cover.name,
	icon = { string = icons.media.back },
	label = { drawing = false },
	click_script = "nowplaying-cli previous",
})
sbar.add("item", {
	position = "popup." .. media_cover.name,
	icon = { string = icons.media.play_pause },
	label = { drawing = false },
	click_script = "nowplaying-cli togglePlayPause",
})
sbar.add("item", {
	position = "popup." .. media_cover.name,
	icon = { string = icons.media.forward },
	label = { drawing = false },
	click_script = "nowplaying-cli next",
})

local interrupt = 0
local function animate_detail(detail)
	if not detail then
		interrupt = interrupt - 1
	end
	if interrupt > 0 and not detail then
		return
	end

	sbar.animate("tanh", 30, function()
		media_artist:set({ label = { width = detail and "dynamic" or 0 } })
		media_title:set({ label = { width = detail and "dynamic" or 0 } })
	end)
end

media_cover:subscribe("routine", function()
	local title, artist
	cmd("nowplaying-cli get title", function(result)
		title = result
	end)
	cmd("nowplaying-cli get artist", function(result)
		artist = result
	end)
	local drawing = (title ~= "null\n")
	media_artist:set({ drawing = drawing, label = artist })
	media_title:set({ drawing = drawing, label = title })

	if drawing then
		animate_detail(true)
		interrupt = interrupt + 1
		-- sbar.delay(5, animate_detail)
	else
		media_cover:set({ popup = { drawing = false } })
	end
end)

media_cover:subscribe("mouse.entered", function(env)
	interrupt = interrupt + 1
	animate_detail(true)
end)

media_cover:subscribe("mouse.exited", function(env)
	animate_detail(false)
end)

media_cover:subscribe("mouse.clicked", function(env)
	media_cover:set({ popup = { drawing = "toggle" } })
end)

media_title:subscribe("mouse.exited.global", function(env)
	media_cover:set({ popup = { drawing = false } })
end)
