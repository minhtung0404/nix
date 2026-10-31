{ lib, ... }:
{
  den.aspects.ios = {
    nixos =
      { pkgs, ... }:
      {
        services.usbmuxd.enable = true;
        services.usbmuxd.package = pkgs.usbmuxd2;
        environment.systemPackages = with pkgs; [
          libimobiledevice
          ifuse
        ];
        systemd.network.networks."05-ios-tethering" = {
          matchConfig.Driver = "ipheth";
          networkConfig.DHCP = "yes";
          linkConfig.RequiredForOnline = "no";
        };
      };

    # every user of the host can access the iOS devices (nix-darwin users have
    # no extraGroups)
    provides.to-users =
      { host, ... }:
      lib.optionalAttrs (host.class == "nixos") {
        user =
          { osConfig, ... }:
          {
            extraGroups = [ osConfig.services.usbmuxd.group ];
          };
      };
  };
}
