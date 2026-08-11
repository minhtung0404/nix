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
    }
  ];

}
