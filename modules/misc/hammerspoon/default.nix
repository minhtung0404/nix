{ pkgs, ... }:
let
  hs = pkgs.runCommand "hs" { } ''
    defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/.config/hammerspoon/init.lua";
  '';
in { xdg.configFile.hammerspoon.source = ./config; }
