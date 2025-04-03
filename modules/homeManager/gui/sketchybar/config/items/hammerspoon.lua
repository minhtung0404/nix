local icons = require("icons")

local hs = sbar.add("item", "widgets.hs", {
	position = "right",
	background = {
		padding_left = 5,
		padding_right = 5,
	},
	icon = {
		string = icons.caffeinate.off_hs,
	},
	label = {
		padding_left = 0,
		padding_right = 0,
	},
	popup = {
		align = "center",
		height = 30,
	},

	update_freq = 180,
})

sbar.exec("osascript ${CONFIG_DIR}/plugins/hammerspoon.scpt --query 1", function(result)
	hs:set({
		icon = result,
	})
end)

local hs_caffeinate = sbar.add("item", "widgets.hs.caffeinate", {
	position = "popup." .. hs.name,
	label = "Caffeinate",
})
local hs_reload = sbar.add("item", "widgets.hs.reload", {
	position = "popup." .. hs.name,
	click_script = "osascript ${CONFIG_DIR}/plugins/hammerspoon.scpt --toggle 3",
	label = "Reload config",
})
local hs_console = sbar.add("item", "widgets.hs.console", {
	position = "popup." .. hs.name,
	click_script = "osascript ${CONFIG_DIR}/plugins/hammerspoon.scpt --toggle 4",
	label = "Show console",
})
local bitwarden = sbar.add("item", "widgets.bitwarden", {
	position = "popup." .. hs.name,
	click_script = "osascript ${CONFIG_DIR}/plugins/bitwarden.scpt",
	label = "Bitwarden",
})

local function hammerspoon(env, type, item_number)
	type = type or "--query"
	item_number = item_number or 1
	sbar.exec("osascript ${CONFIG_DIR}/plugins/hammerspoon.scpt " .. type .. " " .. item_number, function(result)
		hs:set({
			icon = result,
		})
	end)
end

hs:subscribe("mouse.clicked", function(env)
	if env.BUTTON == "left" then
		hs:set({ popup = { drawing = "toggle" } })
	else
		hammerspoon(env, "--toggle", 1)
	end
end)

hs:subscribe("mouse.exited.global", function()
	hs:set({ popup = { drawing = false } })
end)

hs_caffeinate:subscribe("mouse.clicked", function(env)
	hs:set({ popup = { drawing = "toggle" } })
	hammerspoon(env, "--toggle", 1)
end)

hs_reload:subscribe("mouse.clicked", function(env)
	hs:set({ popup = { drawing = "toggle" } })
	hammerspoon(env, "--toggle", 3)
end)

hs_console:subscribe("mouse.clicked", function(env)
	hs:set({ popup = { drawing = "toggle" } })
	hammerspoon(env, "--toggle", 4)
end)

bitwarden:subscribe("mouse.clicked", function(env)
	hs:set({ popup = { drawing = "toggle" } })
end)

hs:subscribe("routine", function(env)
	hammerspoon(env, "--query", 1)
end)
