{ den, lib, ... }:
let
  username = "minhtung0404";

  # home config on nixos hosts
  nixosHome =
    { pkgs, config, ... }:
    {
      mtn = {
        linux.graphical = {
          startup = [
            pkgs.obsidian
            config.mtn.linux.graphical.defaults.webBrowser.package
          ];

          defaults = {
            webBrowser = {
              package = config.programs.zen-browser.finalPackage;
              desktopFile = "zen-beta.desktop";
            };
          };
        };
      };
    };

  # home config on darwin hosts
  darwinHome =
    { config, ... }:
    {
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
    };
in
{
  den.aspects.${username} = {
    includes = [
      den.batteries.primary-user
      (den.batteries.user-shell "fish")
      den.aspects.gsync
      den.aspects.tex
      # home config of the host aspects (desktop, …)
      den.batteries.host-aspects

      (
        { host, ... }:
        {
          homeManager =
            { ... }:
            {
              imports =
                lib.optional (host.class == "nixos") nixosHome ++ lib.optional (host.class == "darwin") darwinHome;
            };
        }
      )
    ];
  };
}
