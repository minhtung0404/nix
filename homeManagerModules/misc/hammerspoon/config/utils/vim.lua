local unwrap_key = require("utils.vim_unwrap")

local log = hs.logger.new("Vim", "info")
---@class VimMode
---@field modal hs.hotkey.modal
---@field keymap table
---@field exited_key table
---@field current_keymap table
---@field current_cmd string
local VimMode = {}
VimMode.__index = VimMode

function VimMode.new()
  local new_layer = {
    modal = hs.hotkey.modal.new({}, nil),
    keymap = {},
    exited_key = {},
    current_keymap = {},
    current_cmd = "",
  }
  setmetatable(new_layer, VimMode)

  return new_layer
end

function VimMode:type(char)
  if self.current_cmd == "" then
    self.current_keymap = self.keymap
  end

  if not self.current_keymap[char] then
    self.current_cmd = ""
    return
  end

  self.current_keymap = self.current_keymap[char]

  if self.current_keymap.is_end then
    self.current_keymap.pressedfn()
    self.current_cmd = ""
  else
    self.current_cmd = self.current_cmd .. char
  end
end

function VimMode:insert(command, callback, is_repeat)
  local keymap = self.keymap

  local key_code = ""
  local is_bracket = false

  for i = 1, #command do
    local char = command:sub(i, i)
    if char == "<" or is_bracket then
      is_bracket = true
      key_code = key_code .. char
      if char == ">" then
        is_bracket = false
      end
    else
      key_code = char
    end

    if not is_bracket then
      if not self.exited_key[key_code] then
        self.exited_key[key_code] = true
        local mods, key = unwrap_key(key_code)
        local function press()
          self:type(key_code)
        end
        log.d(key_code, hs.inspect(mods), key)
        if is_repeat then
          self.modal:bind(mods, key, press, nil, press)
        else
          self.modal:bind(mods, key, press)
        end
      end

      if not keymap[key_code] then
        keymap[key_code] = {}
      end
      keymap = keymap[key_code]

      if i == #command then
        keymap.is_end = true
        keymap.pressedfn = callback
      end
    end
  end
end

---@class Vim
---@field mode table[VimMode]
local Vim = {}
Vim.__index = Vim

function Vim.new()
  local new_layer = {
    mode = {
      n = VimMode.new(),
      v = VimMode.new(),
      i = VimMode.new(),
    },
    current_mode = nil,
  }

  setmetatable(new_layer, Vim)

  return new_layer
end

function Vim:insert(mode, command, callback, is_repeat)
  self.mode[mode]:insert(command, callback, is_repeat)
end

function Vim:switch_mode(to, callback)
  if self.current_mode then
    self.mode[self.current_mode].modal:exit()
  end
  if type(callback) == "function" then
    callback()
  end
  self.current_mode = to
  if self.current_mode then
    self.mode[self.current_mode].modal:enter()
  end
end

return Vim
