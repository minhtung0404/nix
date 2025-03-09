-- mimic i3 behavior
--
local vim_direction = require("utils.vim_direction")
local query = require("utils.query")
local log = hs.logger.new("i3", "info")

local wm = {}

for key, direction in pairs(vim_direction.direction.window) do
  local hotkey = hs.hotkey.bind({ "cmd" }, key, function()
    query.yabai("query --spaces --space", function(space)
      if space.type == "bsp" then
        query.yabai("window --focus " .. direction)
      else
        if key == "k" or key == "h" then
          query.yabai("window --focus stack.prev")
        else
          query.yabai("window --focus stack.next")
        end
      end
    end)
  end)
  if key == "k" then
    wm.cmdk = hotkey
  end
  hs.hotkey.bind({ "cmd", "shift" }, key, function()
    query.yabai("window --swap " .. direction)
  end)
end

hs.hotkey.bind({ "cmd" }, "return", function()
  hs.osascript.applescriptFromFile(hs.configdir .. "/scripts/openkitty.scpt")
end)

hs.hotkey.bind({ "shift", "cmd" }, "f", function()
  query.yabai("window --toggle zoom-fullscreen")
end)

for i = 1, 7 do
  hs.hotkey.bind({ "shift", "cmd" }, tostring(i), function()
    query.yabai("query --windows --window", function(window)
      query.yabai("window --space " .. i, function(_)
        query.yabai("window --focus " .. window.id)
      end)
    end)
  end)
end

return wm
