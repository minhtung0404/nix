{
  description = "Nix configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:lnl7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs@{ self, home-manager, sops-nix, ... }:
    let nixpkgsConfig = { config.allowUnfree = true; };
    in {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#simple
      darwinConfigurations = let inherit (inputs.nix-darwin.lib) darwinSystem;
      in {
        "MacAir-PirateKing" = darwinSystem {
          system = "aarch64-darwin";

          specialArgs = { inherit inputs; };

          modules = [
            ./hosts/mba.nix
            inputs.home-manager.darwinModules.home-manager
            {
              nixpkgs = nixpkgsConfig;

              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.minhtung0404 =
                import ./home/darwin/minhtung0404.nix;
              home-manager.users.entertainment =
                import ./home/darwin/entertainment.nix;

            }
            inputs.sops-nix.darwinModules.sops
          ];
        };
      };
    };
}
