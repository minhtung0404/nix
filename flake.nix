{
  description = "Nix configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:lnl7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    nix-homebrew.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.inputs.nix-darwin.follows = "nix-darwin";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs@{ self, home-manager, sops-nix, nix-homebrew, ... }:
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

            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                enable = true;
                enableRosetta = true;
                user = "minhtung0404";
                autoMigrate = true;
              };
            }

            inputs.home-manager.darwinModules.home-manager
            {
              nixpkgs = nixpkgsConfig;

              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.minhtung0404 =
                import ./home/darwin/minhtung0404.nix;
              home-manager.users.entertainment =
                import ./home/darwin/entertainment.nix;
              home-manager.sharedModules =
                [ inputs.sops-nix.homeManagerModules.sops ];

            }
            inputs.sops-nix.darwinModules.sops
          ];
        };
      };
    };
}
