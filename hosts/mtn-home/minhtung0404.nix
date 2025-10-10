{ pkgs, config, ... }:
let
  user = "minhtung0404";
  home = "/home/minhtung0404";
in
{
  mtn = {
    hm.enable = true;
    username = user;
    programs = {
      my-zenbrowser.enable = true;
    };
  };

  home.username = user;
  home.homeDirectory = home;
}
