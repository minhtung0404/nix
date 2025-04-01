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

    flake-parts.url = "github:hercules-ci/flake-parts";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    # build tools
    crane.url = "github:ipetkov/crane";

    # kakoune
    kakoune.url = "github:mawww/kakoune";
    kakoune.flake = false;
    kak-lsp.url = "github:kakoune-lsp/kakoune-lsp";
    kak-lsp.flake = false;

  };
  outputs = inputs@{ self, nixpkgs, home-manager, sops-nix, nix-homebrew, ... }:
    let
      overlays = import ./overlays.nix inputs;
      nixpkgsConfig = {
        config.allowUnfree = true;
        overlays = overlays; # Apply the overlay here
      };
    in {
      overlays.default = nixpkgs.lib.composeManyExtensions overlays;
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#simple
      darwinConfigurations = let
        inherit (inputs.nix-darwin.lib) darwinSystem;
        system = "aarch64-darwin";
      in {
        "MacAir-PirateKing" = darwinSystem {
          system = system;

          specialArgs = { inherit inputs; };

          modules = [
            ./hosts/mba.nix
            ({ pkgs, ... }: {
              nixpkgs.overlays = overlays; # Apply the overlay here
              environment.systemPackages = with pkgs; [ myCustomPackage ];
            })

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

              # home-manager.extraSpecialArgs = { inherit nixvim-conf; };
            }
            inputs.sops-nix.darwinModules.sops
          ];
        };
      };
    };
}
