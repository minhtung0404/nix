{ config, inputs, pkgs, ... }:
let user = "minhtung0404";
in {
  minhtung0404.username = user;

  imports = [
    # inputs.sops-nix.homeManagerModules.sops
    ../shared/common.nix
    ./common.nix
  ];

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

  # sops.defaultSopsFile = ../../secrets/secrets.yaml;
  # sops.defaultSopsFormat = "yaml";

  # sops.age.keyFile = "/Users/${user}/.config/sops/age/keys.txt";
  # sops.secrets.veracrypt_drive = {
  #   mode = "0440";
  #   owner = user;
  # };
}
