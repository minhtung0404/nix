{ config, pkgs, ...}:

{
  imports = [
    ./common.nix
    ./common-darwin.nix
    ../modules/gui/sketchybar
  ];
  
  config.minhtung0404.services.sketchybar = {
    enable = true;
    extraPackages = [pkgs.lua5_4_compat pkgs.aerospace pkgs.nowplaying-cli pkgs.sketchybar-app-font];
    username = "entertainment";
  };
}
