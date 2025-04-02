---@diagnostic disable: duplicate-set-field
local App = require("keyboards.app.app")
local wm = require("keyboards.wm")
---@class VsCode : AppKeyboard
local vscode = App.new("Vscode", { Code = true }, "info")

function vscode.modal:entered()
  wm.cmdk:disable()
end

function vscode.modal:exited()
  wm.cmdk:enable()
end
