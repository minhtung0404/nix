{ lib, config, ... }:
{
  imports = [
    ../shared
  ];

  homebrew = {
    enable = true;

    brews = [ "mas" ];

    casks = [
      "scroll-reverser"
      "hammerspoon"
    ];

    masApps = {
      "Messenger" = 1480068668;
      "Bitwarden" = 1352778147;
    };

    onActivation.cleanup = "zap";
  };

  launchd.daemons.dnscrypt-proxy.serviceConfig.UserName = lib.mkForce "root";

  system.activationScripts = {
    postActivation = {
      text = lib.mkOrder 1600 ''
        echo "Permission required ..."
        echo "kanata: Please enable Input Mornitoring/Full Disk Access for ${config.mtn.services.my-kanata.package}/bin/kanata"
      '';
    };
  };

}
