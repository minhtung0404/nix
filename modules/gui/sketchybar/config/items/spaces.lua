local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local spaces = {}
local space_brackets = {}
local current_space = nil

sbar.add("event", "aerospace_workspace_change")
sbar.add("event", "aerospace_monitor_change")

local space_icons = { "🌐", "💻", "📝", "📩", "💬", "🎮", "7" }

for i, space_icon in ipairs(space_icons) do
	local space = sbar.add("space", "space." .. i, {
		icon = {
			font = { family = settings.font.numbers },
			string = space_icon,
			padding_left = 15,
			padding_right = 8,
			color = colors.black,
			highlight_color = colors.black,
		},
		label = {
			padding_right = 20,
			color = colors.grey,
			highlight_color = colors.white,
			font = "sketchybar-app-font:Regular:16.0",
			y_offset = -1,
		},
		padding_right = 1,
		padding_left = 1,
		background = {
			color = colors.white,
			border_width = 1,
			height = settings.background_height or 26,
			border_color = colors.black,
		},
		popup = { background = { border_width = 5, border_color = colors.black } },
		associated_display = space_icon == "7" and 2 or 1,
	})

	-- Single item bracket for space items to achieve double border on highlight
	local space_bracket = sbar.add("bracket", { space.name }, {
		background = {
			color = colors.transparent,
			border_color = colors.bg2,
			height = settings.spaces_background_height or 28,
			border_width = 2,
		},
	})

	spaces[i] = space
	space_brackets[i] = space_bracket

	-- Padding space
	sbar.add("space", "space.padding." .. i, {
		space = i,
		script = "",
		width = settings.group_paddings,
	})

	local space_popup = sbar.add("item", {
		position = "popup." .. space.name,
		padding_left = 5,
		padding_right = 0,
		background = {
			drawing = true,
			image = {
				corner_radius = 9,
				scale = 0.2,
			},
		},
	})

	space:subscribe("mouse.clicked", function(env)
		sbar.exec("aerospace workspace " .. env.NAME:sub(7))
	end)

	space:subscribe("mouse.exited", function(_)
		space:set({ popup = { drawing = false } })
	end)
end

---------------------------------------------------

local space_window_observer = sbar.add("item", {
	drawing = false,
	updates = true,
})

local function reload_icon()
	sbar.exec('aerospace list-windows --all --format "%{workspace}%{app-name}" --json', function(env)
		local space_apps = {}
		for _, v in pairs(env) do
			if space_apps[v.workspace] == nil then
				space_apps[v.workspace] = { v["app-name"] }
			else
				table.insert(space_apps[v.workspace], v["app-name"])
			end
		end

		for space, _ in ipairs(space_icons) do
			local apps = space_apps[tostring(space)]
			local icon_line = ""
			if apps then
				for _, app in pairs(apps) do
					local lookup = app_icons[app]
					local icon = ((lookup == nil) and app_icons["default"] or lookup)
					icon_line = icon_line .. " " .. icon
				end
			else
				icon_line = " —"
			end
			sbar.animate("tanh", 10, function()
				spaces[space]:set({ label = icon_line })
			end)
		end
	end)
end

local function reload_space_monitor()
	-- move space to monitor
	for i = 1, 2, 1 do
		sbar.exec("aerospace list-workspaces --monitor " .. i, function(env)
			for workspace in string.gmatch(env, "%S+") do
				local id = tonumber(workspace)
				if space_icons[id] ~= nil then
					spaces[id]:set({
						associated_display = i,
					})
				end
			end
		end)
	end
end

local function space_change(id, selected)
	if id == nil or spaces[id] == nil then
		return
	end
	spaces[id]:set({
		icon = { highlight = selected },
		label = { highlight = selected },
		background = {
			border_color = selected and colors.black or colors.bg2,
			color = selected and colors.red or colors.white,
		},
	})
	space_brackets[id]:set({
		background = { border_color = selected and colors.grey or colors.bg2 },
	})
end

space_window_observer:subscribe("aerospace_workspace_change", function(env)
	space_change(current_space, false)
	current_space = tonumber(env.FOCUSED_WORKSPACE)
	space_change(current_space, true)
	reload_icon()
end)

space_window_observer:subscribe("space_windows_change", function()
	reload_icon()
end)

space_window_observer:subscribe("aerospace_monitor_change", function()
	reload_space_monitor()
end)

---------------------------------------------------

local spaces_indicator = sbar.add("item", {
	padding_left = -3,
	padding_right = 0,
	icon = {
		padding_left = 8,
		padding_right = 9,
		color = colors.blue,
		string = icons.switch.on,
	},
	label = {
		width = 0,
		padding_left = 0,
		padding_right = 8,
		string = "Spaces",
		color = colors.bg1,
	},
	background = {
		color = colors.with_alpha(colors.grey, 0.0),
		border_color = colors.with_alpha(colors.bg1, 0.0),
	},
})

spaces_indicator:subscribe("swap_menus_and_spaces", function(env)
	local currently_on = spaces_indicator:query().icon.value == icons.switch.on
	spaces_indicator:set({
		icon = currently_on and icons.switch.off or icons.switch.on,
	})
end)

spaces_indicator:subscribe("mouse.entered", function(env)
	sbar.animate("tanh", 30, function()
		spaces_indicator:set({
			background = {
				color = { alpha = 1.0 },
				border_color = { alpha = 1.0 },
			},
			icon = { color = colors.bg1 },
			label = { width = "dynamic" },
		})
	end)
end)

spaces_indicator:subscribe("mouse.exited", function(env)
	sbar.animate("tanh", 30, function()
		spaces_indicator:set({
			background = {
				color = { alpha = 0.0 },
				border_color = { alpha = 0.0 },
			},
			icon = { color = colors.grey },
			label = { width = 0 },
		})
	end)
end)

spaces_indicator:subscribe("mouse.clicked", function(env)
	sbar.trigger("swap_menus_and_spaces")
end)

---------------------------------------------------
-- start up
reload_icon()

-- highlight current workspace
sbar.exec("aerospace list-workspaces --focused", function(env)
	current_space = tonumber(env)
	space_change(current_space, true)
end)

-- move space to monitor
reload_space_monitor()
