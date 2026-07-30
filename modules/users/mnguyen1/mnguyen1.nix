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
            tex
            graphical
          ];
          mtn = {
            programs = {
              my-kitty.mod = "alt+shift";
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
            sops
            google-chrome
          ];
        };
    }
  ];

}
