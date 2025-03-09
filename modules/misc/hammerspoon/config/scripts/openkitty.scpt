set appName to "kitty"

if application appName is running then
  Do Shell Script "kitty_socket=$(ls /tmp/ | grep mykitty | head -n 1) && /opt/homebrew/bin/kitty @ --to unix:/tmp/$kitty_socket action spawn_window"
else
  tell application appName to activate
end if
