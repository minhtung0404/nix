{
  pkgs,
  config,
  ...
}:
let
  user = "minhtung0404";
  home = "/home/minhtung0404";
in
{
  mtn = {
    hm.enable = true;
    username = user;
    programs = {
      my-zenbrowser.enable = true;
      my-niri.enable = true;
      my-waybar = {
        enable = true;
        fontSize = 15.0;
        enableMpd = true;
      };
    };

    linux.graphical = {
      type = "wayland";
      wallpaper = ../../images/kuriyama_mirai.png;
      defaults = {
        webBrowser = {
          package = config.programs.zen-browser.finalPackage;
          desktopFile = "zen.desktop";
        };
      };
    };
  };

  home.username = user;
  home.homeDirectory = home;
  home.packages = with pkgs; [
    texlive.combined.scheme-full
    bibtool
    sops
  ];
}
