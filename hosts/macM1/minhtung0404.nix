{ config, inputs, pkgs, ... }:
let
  user = "minhtung0404";
  home = "/Users/${user}/";
in {
  mtn = {
    hm = {
      enable = true;
      darwin = true;
    };

    username = user;
  };

  home.username = user;
  home.homeDirectory = home;

  home.packages = with pkgs; [ texlive.combined.scheme-full sops ];

}
