{
  myLib,
  lib,
  config,
  ...
}:
{
  imports = [
    ./aerospace
    ./sketchybar
    ./caddy.nix
    ./komga.nix
  ]
  ++ (myLib.extendModules (myLib.extends lib config "services") [ ./hammerspoon ]);
}
