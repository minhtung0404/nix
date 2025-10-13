{
  config,
  inputs,
  lib,
  myLib,
  overlays,
  pkgs,
  self,
  ...
}:
{
  imports = [
    ../shared
    ../shared/services/kanata/darwin.nix
    inputs.home-manager.darwinModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "backup";
      home-manager.sharedModules = [
        self.homeManagerModules.default
        ../home-manager/darwin
        {
          home.packages = with pkgs; [ home-manager ];
        }
      ];
      home-manager.extraSpecialArgs = {
        inherit
          self
          inputs
          myLib
          overlays
          ;
      };
    }
    inputs.nix-homebrew.darwinModules.nix-homebrew
    {
      nix-homebrew = {
        enable = true;
        enableRosetta = true;
        autoMigrate = true;
      };
    }
    inputs.sops-nix.darwinModules.sops
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

  services.tailscale.enable = true;

  system.activationScripts = {
    postActivation = {
      text = lib.mkOrder 1600 ''
        echo "-----------------------------------------------"
        echo "Permission required ..."
        echo "kanata: Please enable Input Mornitoring/Full Disk Access for ${config.mtn.services.my-kanata.package}/bin/kanata"
      '';
    };
  };

}
