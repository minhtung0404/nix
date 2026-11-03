{
  den.aspects.communication =
    { host, ... }:
    {
      homeManager =
        { lib, pkgs, ... }:
        {
          home.packages =
            with pkgs;
            [ telegram-desktop ]
            # linux clients (WhatsApp, Zoom)
            ++ lib.optionals (host.class == "nixos") [
              karere
              zoom-us
            ];
        };
    };
}
