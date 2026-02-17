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
      my-niri = {
        enable = true;
        monitors = {
          main = "DP-1";
          secondary = "HDMI-A-1";
        };
        outputs = {
          "DP-1" = {
            scale = 1.0;
            position = {
              x = 0;
              y = 0;
            };
            focus-at-startup = true;
            variable-refresh-rate = true;
          };
          "HDMI-A-1" = {
            scale = 1.0;
            position = {
              x = 2560;
              y = 0;
            };
          };
        };
      };
      my-waybar = {
        enable = true;
        fontSize = 15.0;
        enableMpd = true;
      };
    };
    services = {
      my-gdrive.enable = true;
    };

    linux.graphical = {
      type = "wayland";
      wallpaper = ../../images/kuriyama_mirai.png;

      startup = [
        pkgs.mattermost-desktop
        pkgs.obsidian
        config.mtn.linux.graphical.defaults.webBrowser.package
      ];

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
    # bibtool
    sops
  ];
}
