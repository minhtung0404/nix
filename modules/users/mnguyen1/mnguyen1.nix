{
  lib,
  self,
  ...
}:
let
  user = "mnguyen1";
in
{
  flake.modules = lib.mkMerge [
    (self.factory.user user true)
    {
      homeManager.${user} =
        {
          self,
          pkgs,
          config,
          ...
        }:
        {
          imports = with self.modules.homeManager; [
            system-desktop
            default
          ];
          mtn = {
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
            google-chrome
          ];
        };
    }
  ];

}
