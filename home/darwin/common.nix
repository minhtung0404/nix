{ config, pkgs, ... }:
let user = config.minhtung0404.username;
in {
  home.stateVersion = "24.11";

  imports = [ ../../modules/misc/hammerspoon ../../modules/gui/sketchybar ];

  programs.home-manager.enable = true;
  programs.direnv.enable = true;

  home.packages = with pkgs; [
    aerospace
    aldente
    hidden-bar
    kanata-with-cmd
    raycast
  ];
}
