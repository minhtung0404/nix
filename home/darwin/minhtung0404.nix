{ config, pkgs, ... }: {
  imports = [ ../shared/common.nix ./common.nix ];

  config.home.packages = with pkgs; [ texlive.combined.scheme-full ];

  config.minhtung0404.services.sketchybar = {
    enable = true;
    extraPackages = [
      pkgs.lua5_4_compat
      pkgs.aerospace
      pkgs.nowplaying-cli
      pkgs.sketchybar-app-font
    ];
  };

  config.minhtung0404.username = "minhtung0404";
}
