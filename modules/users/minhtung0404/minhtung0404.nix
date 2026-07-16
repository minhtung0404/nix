{ lib, self, ... }:
let
  user = "minhtung0404";
in
{
  flake.modules = lib.mkMerge [
    (self.factory.user user true)
    {
      homeManager.${user} =
        {
          pkgs,
          config,
          self,
          ...
        }:
        {
          imports = with self.modules.homeManager; [
            system-desktop
            macosDefaults
            macosDock
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
    }
  ];
}
