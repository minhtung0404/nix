{ lib, self, ... }:
let
  username = "minhtung0404";
in
{
  flake.modules = lib.mkMerge [
    (self.factory.user username true)

    {
      nixos.${username} =
        {
          pkgs,
          config,
          self,
          ...
        }:
        {
          home-manager.users.${username} = {
            imports = with self.modules.homeManager; [
              system-desktop
              scrollingDesktop
              waybar
              graphical
              (
                {
                  pkgs,
                  config,
                  self,
                  ...
                }:
                {
                  mtn = {
                    programs = {
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
                        fontSize = 15.0;
                        enableMpd = true;
                      };
                    };

                    linux.graphical = {
                      type = "wayland";
                      wallpaper = config.mtn.constants.mirai;

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

                  home.packages = with pkgs; [
                    texlive.combined.scheme-full
                    bibtool
                    sops
                  ];
                }
              )
            ];

          };
        };

      darwin.${username} =
        {
          pkgs,
          config,
          self,
          ...
        }:
        {
          home-manager.users.${username} = {
            imports = with self.modules.homeManager; [
              system-desktop
              macosDefaults
              macosDock
              aerospace
              sketchybar
              hammerspoon
            ];

            mtn = {
              programs = {
                my-dock = {
                  apps = [
                    "${config.home.homeDirectory}/Applications/Home Manager Apps/Zen Browser (Beta).app/"
                    "/System/Applications/Mail.app/"
                    "/System/Volumes/Data/Applications/VeraCrypt.app/"
                    "${config.home.homeDirectory}/Applications/Home Manager Apps/Obsidian.app/"
                  ];
                };
              };
            };

            home.packages = with pkgs; [
              texlive.combined.scheme-full
              sops
            ];
          };
        };
    }
  ];
}
