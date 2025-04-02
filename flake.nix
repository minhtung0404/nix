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
      myLib = import ./myLib/default.nix { inherit inputs; };
    in with myLib; {
      overlays.default = nixpkgs.lib.composeManyExtensions overlays;
      darwinConfigurations = {
        "MacAir-PirateKing" =
          mkDarwin "aarch64-darwin" ./hosts/macM1/configuration.nix;
      };

      homeConfigurations = {
        "minhtung0404" = mkHome "aarch64-darwin" ./hosts/macM1/minhtung0404.nix;
        "entertainment" =
          mkHome "aarch64-darwin" ./home/darwin/entertainment.nix;
      };

      homeManagerModules.default = ./homeManagerModules;
      darwinModules.default = ./darwinModules;
    };
}

