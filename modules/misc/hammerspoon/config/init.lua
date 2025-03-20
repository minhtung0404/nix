local menu = require("menu")
local wifi_changer = require("wifi_change")
local keyboards = require("keyboards")
local startup = require("startup")
local axbrowse = require("axbrowse")

require("hs.hotkey").setLogLevel("warning")

---@diagnostic disable-next-line: undefined-field
hs.notify.new({ title = "Hammerspoon", informativeText = "Ready to rock!! 🤘" }):send()

local last_app
hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "b", function()
  local current_app = hs.axuielement.applicationElement(hs.application.frontmostApplication())
  if current_app == last_app then
    axbrowse.browse()
  else
    last_app = current_app
    axbrowse.browse(current_app)
  end
end)

Main_table = {
  menu = menu,
  wifi_changer = wifi_changer,
  keyboards = keyboards,
  startup = startup,
}
