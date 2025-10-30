{
  pkgs,
  config,
  ...
}:
let
  user = "entertainment";
  home = "/Users/${user}/";
in
{
  mtn = {
    hm = {
      enable = true;
      darwin = true;
    };

    username = user;
    programs = {
      my-zenbrowser = {
        enable = true;
        entertainment = true;
      };
      my-dock = {
        enable = true;
        apps = [
          "${home}/Applications/Home Manager Apps/Zen Browser (Beta).app/"
          "${home}/Applications/Home Manager Apps/Obsidian.app/"
        ];
      };
    };
  };

  home.username = user;
  home.homeDirectory = home;
}
