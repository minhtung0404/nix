{
  inputs,
  config,
  pkgs,
  lib,
  myLib,
  ...
}:
let
  user = config.mtn.username;
  cfg = config.mtn.hm;
in
{
  imports = [
    ./darwin-defaults.nix
    ./services/aerospace
    ./services/sketchybar
  ] ++ (myLib.extendModules (myLib.extends lib config "services") [ ./services/hammerspoon ]);

  config = lib.mkIf cfg.darwin {
    home.packages = with pkgs; [
      aldente
      hidden-bar
      kanata-with-cmd
      raycast
      skimpdf
    ];

    mtn = {
      services = {
        my-sketchybar.enable = true;
        my-aerospace.enable = true;
        my-hammerspoon.enable = true;
      };
    };
  };
}
