{
  lib,
  self,
  ...
}:
let
  user = "entertainment";
in
{
  flake.modules = lib.mkMerge [
    (self.factory.user user false)
    {
      homeManager.${user} = { config, self, ... }: {
        imports = with self.modules.homeManager; [
          system-desktop
          macosDefaults
          macosDock
        ];
        mtn = {
          programs = {
            my-zenbrowser = {
              entertainment = true;
            };
            my-dock = {
              apps = [
                "${config.home.homeDirectory}/Applications/Home Manager Apps/Zen Browser (Beta).app/"
                "${config.home.homeDirectory}/Applications/Home Manager Apps/Obsidian.app/"
              ];
            };
          };
        };
      };
    }
  ];
}
