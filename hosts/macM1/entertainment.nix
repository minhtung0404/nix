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
  };

  home.username = user;
  home.homeDirectory = home;
}
