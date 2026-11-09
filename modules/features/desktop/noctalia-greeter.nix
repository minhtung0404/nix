{
  # noctalia's greetd login screen (with its own compositor); the running noctalia pushes
  # its wallpaper, colors and monitor layout to it ([shell.greeter_sync] in noctalia.nix)
  den.aspects.noctaliaGreeter =
    { host, ... }:
    {
      nixos =
        { lib, ... }:
        {
          services.displayManager.noctalia-greeter = {
            enable = true;
            # appearance-only sync without an administrator prompt
            passwordlessSyncUsers = lib.mapAttrsToList (_: user: user.userName) host.users;
          };

          # greetd logins unlock kwallet, like the `login` service (pam aspect)
          security.pam.services.greetd.kwallet.enable = true;
        };
    };
}
