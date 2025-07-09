{
  config,
  inputs,
  lib,
  myLib,
  outputs,
  overlays,
  pkgs,
  self,
  ...
}:
{
  imports = [
    ../shared
    inputs.home-manager.darwinModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "backup";
      home-manager.sharedModules = [
        outputs.homeManagerModules.default
        {
          home.packages = with pkgs; [ home-manager ];
        }
      ];
      home-manager.extraSpecialArgs = {
        inherit
          self
          inputs
          outputs
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
