---@class AppKeyboard
---@field layer_name string
---@field app table
---@field log hs.logger
---@field in_app integer
local App = {}
App.__index = App

function App.new(layer_name, app, log)
  ---@class AppKeyboard
  local new_layer = {
    modal = hs.hotkey.modal.new({}, nil),
    layer_name = layer_name,
    app = app,
    log = hs.logger.new(layer_name, log),
    in_app = 0,
  }

  setmetatable(new_layer, App)

  new_layer:start_watcher()

  return new_layer
end

function App:enter_app()
  self.in_app = self.in_app + 1
  self.log.d("Enter " .. self.layer_name .. " layer")
  self.modal:enter()
end

function App:exit_app()
  self.in_app = math.max(self.in_app - 1, 0)
  self.log.d(self.in_app)
  if self.in_app == 0 then
    self.log.d("Exit " .. self.layer_name .. " layer")
    self.modal:exit()
  end
end

function App:start_watcher()
  self.watcher = hs.application.watcher.new(function(app_name, event_type, _)
    self.log.d(app_name, event_type)
    if self.app[app_name] then
      if event_type == hs.application.watcher.activated then
        self:enter_app()
      elseif event_type == hs.application.watcher.deactivated then
        self:exit_app()
      end
    elseif event_type == hs.application.watcher.activated then
      self:exit_app()
    end
  end)

  self.watcher:start()
end

return App
