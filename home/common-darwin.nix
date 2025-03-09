{ config, pkgs, ... }:

{
  home.stateVersion = "24.11";

  imports = [ ../modules/misc/hammerspoon ];

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
