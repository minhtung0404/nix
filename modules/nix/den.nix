{
  inputs,
  self,
  lib,
  ...
}:
{
  imports = [
    inputs.flake-file.flakeModules.dendritic
    (inputs.den.flakeModules.dendritic or { })
    # still needed while flake.modules.* is being migrated to den.aspects
    inputs.flake-parts.flakeModules.modules
  ];

  flake-file.inputs = {
    den.url = "github:denful/den";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-file.url = "github:vic/flake-file";
    import-tree.url = "github:vic/import-tree";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:lnl7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  systems = [
    "x86_64-linux"
    "aarch64-darwin"
  ];

  # every user gets a home-manager environment, nested in its host
  den.schema.user.classes = lib.mkDefault [ "homeManager" ];

  # Migration bridge: class modules still reach `self.modules.*` through their
  # `self` argument (often inside `imports`), which only works as a specialArg.
  # Drop this once everything is a den aspect.
  den.schema.host.imports = [
    (
      { config, ... }:
      {
        instantiate =
          let
            builder =
              {
                nixos = inputs.nixpkgs.lib.nixosSystem;
                darwin = inputs.nix-darwin.lib.darwinSystem;
              }
              .${config.class};
          in
          args:
          builder (
            args
            // {
              specialArgs = (args.specialArgs or { }) // {
                inherit self inputs;
              };
            }
          );
      }
    )
  ];
}
