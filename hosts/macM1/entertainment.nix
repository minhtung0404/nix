{
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
    programs.my-librewolf.entertainment = true;
  };

  home.username = user;
  home.homeDirectory = home;
}
