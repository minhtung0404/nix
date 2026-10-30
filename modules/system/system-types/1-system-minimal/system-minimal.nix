{ den, ... }:
{
  # default settings needed for all hosts

  den.default = {
    nixos.system.stateVersion = "26.05";
    darwin.system.stateVersion = 6;
    homeManager.home.stateVersion = "26.05";
  };

  den.aspects.system-minimal = {
    includes = [ den.aspects.nixpkgs ];

    # shared by nixos and darwin
    os = {
      nix.settings = {
        substituters = [
          # high priority since it's almost always used
          "https://cache.nixos.org?priority=10"
          "https://install.determinate.systems"
          "https://nix-community.cachix.org"
        ];

        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM"
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];

        experimental-features = [
          "nix-command"
          "flakes"
        ];

        download-buffer-size = 1024 * 1024 * 1024;

        trusted-users = [
          "root"
          "@wheel"
        ];
      };

      nix.extraOptions = ''
        warn-dirty = false
        keep-outputs = true
      '';
    };

    # homeManager on a host-included aspect is dropped by den; to-users routes it
    # to every user of the host
    provides.to-users.homeManager.programs.home-manager.enable = true;
  };
}
