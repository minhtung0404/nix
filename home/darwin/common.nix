{ inputs, config, pkgs, lib, ... }:
let
  user = config.mtn.username;
  cfg = config.mtn.hm;
in {
  imports = [
    ../../modules/misc/hammerspoon
    ../../modules/gui/sketchybar
    ../../modules/gui/aerospace
    ../shared/common.nix
  ];

  config = lib.mkIf cfg.darwin {
    programs.home-manager.enable = true;
    programs.direnv.enable = true;

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
      };
    };
  };
}
