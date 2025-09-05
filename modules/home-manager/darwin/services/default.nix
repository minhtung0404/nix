{
  myLib,
  lib,
  config,
  ...
}:
{
  imports = [
    ./aerospace.nix
    ./caddy.nix
    ./jellyfin.nix
    ./komga.nix
    ./sketchybar
    ./workspaces.nix
  ]
  ++ (myLib.extendModules (myLib.extends lib config "services") [ ./hammerspoon ]);
}
