---@diagnostic disable: undefined-field
local Vim = require("utils.vim")
local vim_unwrap = require("utils.vim_unwrap")

local notifications = hs.axuielement.observer.notifications

---@class LibreWolf : Vim
local librewolf = Vim.new()
librewolf.app_name = "LibreWolf"
librewolf.in_pdf = 0
librewolf.indicator = nil
librewolf.icon = hs.image.imageFromPath("~/.config/hammerspoon/assets/neovim.png")

local log = hs.logger.new(librewolf.app_name, "info")

function librewolf.mode.n.modal:entered()
  log.d("Enter " .. librewolf.app_name .. " layer")

  -- Drawing
  local focused_window = librewolf.app:mainWindow()
  local frame = focused_window:frame()
  if librewolf.indicator then
    librewolf.indicator:hide()
  end
  librewolf.indicator = hs.canvas.new({ x = frame.x, y = frame.y + 100, h = 100, w = 100 })

  if librewolf.indicator then
    librewolf.indicator:appendElements({
      type = "image",
      image = librewolf.icon,
      frame = { w = 30, h = 30, x = 0, y = 0 },
    })

    librewolf.indicator:bringToFront(true)
    librewolf.indicator:show()
  end
end

function librewolf.mode.n.modal:exited()
  log.d("Exit " .. librewolf.app_name .. " layer")

  if librewolf.indicator then
    librewolf.indicator:hide()
  end
end

function librewolf:enter_app()
  librewolf.in_pdf = librewolf.in_pdf | 2
  if self.in_pdf ~= 3 then
    return
  end

  self:switch_mode("n")
end

function librewolf:exit_app()
  self.in_pdf = self.in_pdf & 1

  self:switch_mode(nil)
end

function librewolf:create_ax_watcher()
  self.app = hs.appfinder.appFromName(librewolf.app_name)
  self.app_ui = hs.axuielement.applicationElement(self.app)

  self.ui_watcher = hs.axuielement.observer.new(self.app:pid())

  self.ui_watcher:addWatcher(self.app_ui, notifications.applicationActivated)
  self.ui_watcher:addWatcher(self.app_ui, notifications.applicationDeactivated)
  self.ui_watcher:addWatcher(self.app_ui, notifications.focusedWindowChanged)
  self.ui_watcher:addWatcher(self.app_ui, notifications.windowResized)
  self.ui_watcher:addWatcher(self.app_ui, notifications.focusedUIElementChanged)
  self.ui_watcher:callback(function(_, axuielement, noti, _)
    log.d(noti)
    if noti == notifications.applicationActivated then
      self.in_pdf = self.in_pdf | 1
      if hs.window.focusedWindow() then
        self:enter_app()
      end
    elseif noti == notifications.focusedWindowChanged or noti == notifications.windowResized then
      self:enter_app()
    elseif noti == notifications.applicationDeactivated then
      self.in_pdf = self.in_pdf & 2
      self:exit_app()
    elseif noti == notifications.focusedUIElementChanged then
      log.d(hs.inspect(axuielement:allAttributeValues()))
      if
        axuielement.AXRole == "AXTextField"
        or axuielement.AXRole == "AXTextArea"
        or axuielement.AXRole == "AXComboBox"
        or axuielement.AXDOMIdentifier == "hud-find-input"
        or axuielement.AXDOMIdentifier == "search_form_input"
        or axuielement.AXDescription == "Vomnibar"
      then
        if self.in_pdf == 3 then
          self:switch_mode("i")
        end
      else
        if self.in_pdf == 3 then
          self:switch_mode("n")
        end
      end
    end
  end)
  self.ui_watcher:start()
end

librewolf.app_watcher = hs.application.watcher.new(function(app_name, event, _)
  if app_name == librewolf.app_name then
    if event == hs.application.watcher.launched then
      librewolf:create_ax_watcher()
    elseif event == hs.application.watcher.terminated then
      librewolf.ui_watcher = nil
      librewolf.in_pdf = 0
      librewolf:exit_app()
    end
  end
end)

librewolf.app_watcher:start()
librewolf.app = hs.appfinder.appFromName(librewolf.app_name)
if librewolf.app then
  log.d("Create LibreWolf watcher")
  librewolf:create_ax_watcher()
end

local keymap = {
  H = { mods = { "ctrl", "shift" }, key = "tab" },
  L = { mods = { "ctrl" }, key = "tab" },
  J = { mods = { "cmd" }, key = "left" },
  K = { mods = { "cmd" }, key = "right" },
  X = { mods = { "cmd", "shift" }, key = "t" },
  G = { mods = {}, key = "end" },
  ["gg"] = { mods = {}, key = "home" },
  ["g0"] = { mods = { "cmd" }, key = "1" },
  ["g$"] = { mods = { "cmd" }, key = "9" },
}

local vimium_key = {
  f = "i",
  F = "i",
  v = "v",
  V = "v",
  b = "i",
  B = "i",
  o = "i",
  O = "i",
  T = "i",
  ["/"] = "i",
}

local scroll_step_size = 10

local scroll_map = {
  j = { 0, scroll_step_size },
  k = { 0, -scroll_step_size },
  h = { scroll_step_size, 0 },
  l = { -scroll_step_size, 0 },
}

for from_key, to_key in pairs(keymap) do
  local function press()
    hs.eventtap.keyStroke(to_key.mods, to_key.key)
  end
  librewolf:insert("n", from_key, press, true)
end

for from_key, scroll_direction in pairs(scroll_map) do
  local function scroll()
    hs.eventtap.scrollWheel(scroll_direction, {})
  end
  librewolf:insert("n", from_key, scroll, true)
end

for key_code, mode in pairs(vimium_key) do
  librewolf:insert("n", key_code, function()
    librewolf:switch_mode(mode, function()
      local mods, key = vim_unwrap(key_code)
      hs.eventtap.keyStroke(mods, key)
    end)
  end)
end

librewolf:insert("n", "i", function()
  librewolf:exit_app()
end)

local last_escape = { -1, -1, -1 }

librewolf.escape_watcher = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
  local key_code = event:getKeyCode()

  if hs.keycodes.map[key_code] == "escape" then
    last_escape[0] = last_escape[1]
    last_escape[1] = last_escape[2]
    last_escape[2] = hs.timer.absoluteTime()
    if last_escape[2] - last_escape[0] < 1000000000 then
      librewolf:enter_app()
    end
  end
end)

librewolf.escape_watcher:start()

return librewolf
