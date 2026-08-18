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
              nixosDesktop
              tex
              ({ pkgs, config, ... }: {
                mtn = {
                  linux.graphical = {
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
              })
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

              tex
            ];

            mtn =
              let
                home = config.home-manager.users.${username}.home.homeDirectory;
              in
              {
                programs = {
                  my-dock = {
                    apps = [
                      "${home}/Applications/Home Manager Apps/Zen Browser (Beta).app/"
                      "/System/Applications/Mail.app/"
                      "/System/Volumes/Data/Applications/VeraCrypt.app/"
                      "${home}/Applications/Home Manager Apps/Obsidian.app/"
                    ];
                  };
                };
              };

            home.packages = with pkgs; [
              sops
            ];
          };
        };
    }
  ];
}
