on run argv
  tell application "System Events"
    tell process "Hammerspoon"
      if ((item 1 of argv) = "--toggle")
        tell menu "Hammerspoon" of menu bar 2
          click menu item ((item 2 of argv) as number)
        end tell
      end if
      name of menu item 1 of menu "Hammerspoon" of menu bar 2
    end tell
  end tell
end run
