{
  flake.modules.nixos.kwallet =
    { pkgs, lib, ... }:
    {
      environment.systemPackages = [ pkgs.kdePackages.kwallet ];
      services.dbus.packages = [ pkgs.kdePackages.kwallet ];
      xdg.portal = {
        extraPortals = [ pkgs.kdePackages.kwallet ];
      };
    };
}
