{ den, self, ... }:
{
  # host-only: a { host } function in den.default.includes would also run once
  # per user of the host
  den.schema.host.includes = [ den.batteries.hostname ];

  den.default = {
    includes = [ den.batteries.define-user ];

    nixos.system.stateVersion = "26.05";

    darwin.system.stateVersion = 6;

    homeManager = {
      home.stateVersion = "26.05";
      programs.home-manager.enable = true;
    };

    # shared by nixos and darwin
    os = {
      nixpkgs = {
        config.allowUnfree = true;
        overlays = [ self.overlays.default ];
        flake.setNixPath = true;
      };

      nix.extraOptions = ''
        auto-optimise-store = true
        experimental-features = nix-command flakes
        extra-platforms = x86_64-darwin aarch64-darwin
        extra-nix-path = nixpkgs=flake:nixpkgs
      '';

      # options of the home-manager nixos/darwin module, which den imports for
      # every host that has a user with the homeManager class
      home-manager = {
        backupFileExtension = "backup";
        useUserPackages = true;
        useGlobalPkgs = true;
      };
    };
  };
}
