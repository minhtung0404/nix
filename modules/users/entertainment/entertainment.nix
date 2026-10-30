{
  den,
  ...
}:
let
  user = "entertainment";
in
{
  den.aspects.${user} = {
    includes = [
      den.batteries.define-user
      (den.batteries.user-shell "fish")
    ];

    homeManager =
      { config, self, ... }:
      {
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
  };
}
