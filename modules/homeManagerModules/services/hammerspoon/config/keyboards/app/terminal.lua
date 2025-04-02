local App = require("keyboards.app.app")
local term = App.new("Term", { kitty = true, WezTerm = true }, "info")

local cmd_to_ctrl_keymap = {
  r = { "cmd" },
  a = { "cmd" },
  b = { "cmd" },
  d = { "cmd" },
  u = { "cmd" },
  f = { "cmd" },
}

for key, mods in pairs(cmd_to_ctrl_keymap) do
  term.modal:bind(mods, key, function()
    term.modal:exit()
    term.log.d("pressed " .. key)
    hs.eventtap.keyStroke({ "ctrl" }, key, 50000)
    if term.in_app then
      term.modal:enter()
    end
  end)
end

return term
