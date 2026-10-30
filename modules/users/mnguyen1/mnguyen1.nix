{
  den,
  ...
}:
let
  user = "mnguyen1";
in
{
  den.aspects.${user} = {
    includes = [
      den.batteries.define-user
      den.batteries.primary-user
      (den.batteries.user-shell "fish")
      den.aspects.gsync
    ];

    homeManager =
      {
        self,
        pkgs,
        config,
        ...
      }:
      {
        imports = with self.modules.homeManager; [
          system-desktop
          nixosDesktop
          tex
        ];
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

        home.packages = with pkgs; [
          google-chrome
        ];
      };
  };
}
