{ config, pkgs, ... }: {
  imports = [ ../shared/common.nix ./common.nix ];

  home.packages = with pkgs; [ texlive.combined.scheme-full sops ];

  minhtung0404.services.sketchybar = {
    enable = true;
    extraPackages = [
      pkgs.lua5_4_compat
      pkgs.aerospace
      pkgs.nowplaying-cli
      pkgs.sketchybar-app-font
    ];
  };

  minhtung0404.username = "minhtung0404";
}
