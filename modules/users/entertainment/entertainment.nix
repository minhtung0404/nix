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
      (den.batteries.user-shell "fish")
      # home config of the host aspects (desktop, …)
      den.batteries.host-aspects
    ];

    homeManager =
      { config, ... }:
      {
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
