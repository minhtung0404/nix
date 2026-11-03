{
  den.aspects.diskTools.homeManager =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.gparted ];
    };
}
