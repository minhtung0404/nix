{
  pkgs,
  config,
  ...
}:
let
  user = "mnguyen1";
  home = "/home/${user}";
in
{
  mtn = {
    hm.enable = true;
    username = user;
    programs = {
      my-zenbrowser.enable = true;
      my-niri = {
        enable = true;
        enableLaptop = true;
        monitors = {
          main = "DP-2";
          secondary = "eDP-1";
        };
        outputs = {
          "DP-2" = {
            scale = 1.0;
            position = {
              x = 0;
              y = 0;
            };
            focus-at-startup = true;
          };
          "eDP-1" = {
            scale = 1.0;
            position = {
              x = 1920;
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
    mattermost-desktop
  ];
}
