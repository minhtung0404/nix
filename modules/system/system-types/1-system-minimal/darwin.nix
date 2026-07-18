{ ... }: {
  flake-file.inputs = {
    nix-darwin.url = "github:lnl7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.darwin.system-minimal = { pkgs, self, ... }: {
    imports = [
      self.modules.generic.nixpkgs
    ];
    system.stateVersion = 6;

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
}
