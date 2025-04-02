hs.location.get()

-- local log = hs.logger.new("wifi_change", "info")

local ssid = {
  home_ssid = "Livebox-9C80",
}

local function ssid_changed_callback()
  local new_ssid = hs.wifi.currentNetwork()

  if new_ssid == ssid.home_ssid then
    -- We just joined our home WiFi network
    hs.shortcuts.run("Turn off Not Home")
  elseif new_ssid ~= ssid.home_ssid then
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
