hs.location.get()

-- local log = hs.logger.new("wifi_change", "info")

local ssid = {"Supersonic", "akamatsu1274"}

function is_home(list, str)
  for _, value in ipairs(list) do
    if value == str then
      return true
    end
  end
  return false
end

local function ssid_changed_callback()
  local new_ssid = hs.wifi.currentNetwork()

  if is_home(ssid, new_ssid) then
    -- We just joined our home WiFi network
    hs.shortcuts.run("Turn off Not Home")
  else
    -- We just departed our home WiFi network
    hs.shortcuts.run("Turn on Not Home")
  end
end

local wifi_watcher = hs.wifi.watcher.new(ssid_changed_callback)
wifi_watcher:start()

ssid_changed_callback()

return {
  wifi_watcher = wifi_watcher,
}
