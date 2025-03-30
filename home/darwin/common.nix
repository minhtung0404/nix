{ config, pkgs, lib, ... }:
let
  user = config.minhtung0404.username;
  cfg = config.mtn.hm;
in {
  imports = [
    ../../modules/misc/hammerspoon
    ../../modules/gui/sketchybar
    ../../modules/gui/aerospace
    ../../modules/terminals/kitty
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
    ];

    mtn = {
      services = {
        my-sketchybar.enable = true;
        my-aerospace.enable = true;
      };
      programs = {
        my-nvim.enable = true;
        my-kitty = {
          enable = true;
          fontSize = 16;
          cmd = "cmd";
        };
      };
    };
  };
}
