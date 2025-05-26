{
  outputs,
  lib,
  config,
  ...
}:
{
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [ outputs.overlays.default ];
  };

  imports = [
    ./services/kanata/darwin.nix
    ./services/edns
    ./programs/sops.nix
  ];

  nix = {
    extraOptions = ''
      auto-optimise-store = true
      experimental-features = nix-command flakes
      extra-platforms = x86_64-darwin aarch64-darwin
      extra-nix-path = nixpkgs=flake:nixpkgs
    '';
    gc = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 2;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
    };
  };
  nixpkgs.flake.setNixPath = true;

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

  programs.fish = {
    enable = true;
    vendor.completions.enable = true;
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
