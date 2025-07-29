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
      # my-librewolf.enable = true;
      my-zenbrowser = {
        enable = true;
        entertainment = true;
      };
      my-dock = {
        enable = true;
        apps = [
          "${config.programs.zen-browser.finalPackage}/Applications/Zen Browser (Beta).app/"
          "/System/Applications/Mail.app/"
          "/System/Volumes/Data/Applications/VeraCrypt.app/"
          "${pkgs.obsidian}/Applications/Obsidian.app/"
        ];
      };
    };
  };

  home.username = user;
  home.homeDirectory = home;
}
