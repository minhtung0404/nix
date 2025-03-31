{ pkgs, ... }: {
  xdg.configFile.hammerspoon = {
    source = ./config;
    recursive = true;
  };
  home.sessionPath = [ "/usr/bin" "/bin" "/usr/sbin" "/sbin" ];
  home.activation = {
    hammerspoon = ''
      run /usr/bin/defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/.config/hammerspoon/init.lua"'';
  };
}
