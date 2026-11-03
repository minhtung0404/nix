{
  den.aspects.kwallet.nixos =
    { pkgs, lib, ... }:
    {
      environment.systemPackages = [
        pkgs.kdePackages.kwallet
        pkgs.libsForQt5.qtkeychain
      ];
      services.dbus.packages = [ pkgs.kdePackages.kwallet ];
      xdg.portal = {
        extraPortals = [ pkgs.kdePackages.kwallet ];
      };
    };
}
