{
  den.aspects.fonts.homeManager =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.nerd-fonts.fira-code ];
    };
}
