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
    flake-utils.url = "github:numtide/flake-utils";

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

    # nki-kakoune
    nki-nix-home.url = "git+https://git.dtth.ch/nki/nix-home.git";
    nki-nix-home.inputs = {
      nixpkgs-unstable.follows = "nixpkgs";
      darwin.follows = "nix-darwin";
      home-manager.follows = "home-manager";
      sops-nix.follows = "sops-nix";
      flake-utils.follows = "flake-utils";
    };

    # neovim
    nvf.url = "github:notashelf/nvf";
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      nvf,
      ...
    }:
    let
      myLib = import ./myLib/default.nix { inherit inputs; };
      system = "aarch64-darwin";
      pkgs = import nixpkgs {
        system = system;
        overlays = import ./overlays.nix inputs;
      };
    in
    with myLib;
    {
      overlays.default = nixpkgs.lib.composeManyExtensions (import ./overlays.nix inputs);
      darwinConfigurations = {
        "MacAir-PirateKing" = mkDarwin system ./hosts/macM1/configuration.nix;
      };

      homeConfigurations = {
        "minhtung0404" = mkHome system ./hosts/macM1/minhtung0404.nix;
        "entertainment" = mkHome system ./home/darwin/entertainment.nix;
      };

      homeManagerModules.default = ./modules/homeManager;
      darwinModules.default = ./modules/darwin;

      packages.${system} = {
        neovim =
          (nvf.lib.neovimConfiguration {
            pkgs = nixpkgs.legacyPackages.${system};
            modules = [ ./modules/homeManagerModules/editors/nvim/nvf.nix ];
          }).neovim;

        nki-kakoune = pkgs.nki-kakoune;
      };
    };
}
