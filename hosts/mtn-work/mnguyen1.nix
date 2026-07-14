{
  self,
  pkgs,
  config,
  ...
}:
let
  user = "mnguyen1";
  home = "/home/${user}";
in
{
  flake.modules.nixos.mnguyen1 = { ... }: {
    home-manager.users.${user} = {
      imports = [
        self.modules.homeManager.default
        self.modules.homeManager.mnguyen1
      ];
    };
  };

  flake.modules.homeManager.mnguyen1 = { pkgs, config, ... }: {
    imports = [
      self.modules.homeManager.system-default

      self.modules.homeManager.cliTools
      self.modules.homeManager.zenBrowser
      self.modules.homeManager.kakoune
      self.modules.homeManager.vesktop
      self.modules.homeManager.gsync
      self.modules.homeManager.fish
      self.modules.homeManager.fishTide
      self.modules.homeManager.kitty
      self.modules.homeManager.scrollingDesktop
      self.modules.homeManager.waybar
      self.modules.homeManager.graphical
    ];
    mtn = {
      hm.enable = true;
      constants.username = user;
      programs = {
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
          fontSize = 15.0;
          enableMpd = true;
        };
      };

      linux.graphical = {
        type = "wayland";
        wallpaper = ../../images/kuriyama_mirai.png;

        startup = [
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
      bibtool
      sops
      google-chrome
    ];
  };
}
