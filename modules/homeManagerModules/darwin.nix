{ inputs, config, pkgs, lib, ... }:
let
  user = config.mtn.username;
  cfg = config.mtn.hm;
in {
  config = lib.mkIf cfg.darwin {
    home.packages = with pkgs; [
      aerospace
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

