{
  flake.modules.nixos.ios =
    { config, pkgs, ... }:
    {
      services.usbmuxd.enable = true;
      services.usbmuxd.package = pkgs.usbmuxd2;
      environment.systemPackages = with pkgs; [
        libimobiledevice
        ifuse
      ];
      users.users.${config.mtn.constants.username}.extraGroups = [ config.services.usbmuxd.group ];
      systemd.network.networks."05-ios-tethering" = {
        matchConfig.Driver = "ipheth";
        networkConfig.DHCP = "yes";
        linkConfig.RequiredForOnline = "no";
      };
    };
}
