{
  description = "Nix configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:lnl7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    # kakoune
    mtn-kakoune = {
      url = "github:minhtung0404/kakoune-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
      # to have it up-to-date or simply don't specify the nixpkgs input
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    niri.url = "github:sodiboo/niri-flake";
    # niri.inputs.nixpkgs.follows = "nixpkgs";

  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-parts,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      top: with import ./my-lib/default.nix { inherit self inputs; }; {
        flake = {
          overlays.default = nixpkgs.lib.composeManyExtensions (import ./overlays.nix inputs);

          nixosConfigurations = {
            "mtnPC" = mkNixos "x86_64-linux" ./hosts/mtn-home/configuration.nix;
            "mtnWork" = mkNixos "x86_64-linux" ./hosts/mtn-work/configuration.nix;
          };

          darwinConfigurations = {
            "MacAir-PirateKing" = mkDarwin "aarch64-darwin" ./hosts/macM1/configuration.nix;
          };

          homeConfigurations = {
            "minhtung0404" = mkHome "aarch64-darwin" ./hosts/macM1/minhtung0404.nix;
            "entertainment" = mkHome "aarch64-darwin" ./home/darwin/entertainment.nix;
          };

          nixosModules.default = ./modules/nixos;
          homeManagerModules.default = ./modules/home-manager;
          darwinModules.default = ./modules/darwin;
        };
      }
    );
}
