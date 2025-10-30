{
  pkgs,
  config,
  ...
}:
let
  user = "minhtung0404";
  home = "/Users/${user}/";
in
{
  mtn = {
    hm = {
      enable = true;
      darwin = true;
    };

    username = user;
    programs = {
      my-zenbrowser.enable = true;
      my-dock = {
        enable = true;
        apps = [
          "${home}/Applications/Home Manager Apps/Zen Browser (Beta).app/"
          "/System/Applications/Mail.app/"
          "/System/Volumes/Data/Applications/VeraCrypt.app/"
          "${home}/Applications/Home Manager Apps/Obsidian.app/"
        ];
      };
    };

    services = {
      my-hammerspoon.enable = true;
      # my-komga.enable = true;
      # my-caddy.enable = true;
      # my-jellyfin.enable = true;
    };
  };

  home.username = user;
  home.homeDirectory = home;

  home.packages = with pkgs; [
    texlive.combined.scheme-full
    sops
  ];
}
