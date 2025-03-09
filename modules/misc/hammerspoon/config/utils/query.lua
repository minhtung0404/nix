local log = hs.logger.new("query", "info")

local function task_cb(fn)
  return function(...)
    local out = { ... }

    local is_hstask = function(x) -- {{{
      return #x == 3 and tonumber(x[1]) and u.isstring(x[2])
    end -- }}}

    if is_hstask(out) then
      local stdout = out[2]

      if type(stdout) == "string" and stdout:find("{") and stdout:find("}") then
        -- NOTE: hs.json.decode cannot parse "inf" values
        -- yabai response may have "inf" values: e.g., frame":{"x":inf,"y":inf,"w":0.0000,"h":0.0000}
        -- So, we must replace ":inf," with ":0,"
        local clean = stdout:gsub(":inf,", ":0,")
        stdout = hs.json.decode(clean)
      end

      return fn(stdout)
    end

    -- fallback if 'out' is not from hs.task
    return fn(out)
  end
end

local function yabai(command, callback) -- {{{
  callback = callback or function(x)
    return x
  end
  command = "-m " .. command

  log.d(command)

  hs.task
    .new(
      "/opt/homebrew/bin/yabai",
      task_cb(callback), -- wrap callback in json decoder
      command:split(" ")
    )
    :start()
end -- }}}

return {
  yabai = yabai,
}
