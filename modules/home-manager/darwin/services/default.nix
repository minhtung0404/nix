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
    ./jellyfin.nix
  ]
  ++ (myLib.extendModules (myLib.extends lib config "services") [ ./hammerspoon ]);
}
