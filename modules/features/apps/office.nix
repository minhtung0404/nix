{
  den.aspects.office =
    { host, ... }:
    {
      homeManager =
        { lib, pkgs, ... }:
        {
          home.packages =
            with pkgs;
            [ obsidian ] ++ lib.optionals (host.class == "nixos") [ onlyoffice-desktopeditors ];
        };
    };
}
