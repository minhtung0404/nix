-- spoof
hs.execute("sudo ~/.local/bin/change_mac_address.sh", true)

-- login watcher
local login_watcher = hs.caffeinate.watcher.new(function(event)
  if
    event == hs.caffeinate.watcher.systemDidWake
    or event == hs.caffeinate.watcher.sessionDidBecomeActive
    or event == hs.caffeinate.watcher.screensDidUnlock
  then
    print("Login")
    hs.execute("/opt/homebrew/bin/brew services restart sketchybar")
  end
end)

login_watcher:start()

return { login_watcher }
