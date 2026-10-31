{
  den,
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.flake-file.flakeModules.dendritic
    (inputs.den.flakeModules.dendritic or { })
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

  # networking.hostName = den.hosts.<system>.<name>.hostName (defaults to the
  # host name) on every host
  den.schema.host.includes = [ den.batteries.hostname ];

  # den builds darwin hosts with inputs.darwin by default; this flake calls the
  # input nix-darwin
  den.schema.host.imports = [
    (
      { config, ... }:
      lib.mkIf (config.class == "darwin") {
        instantiate = inputs.nix-darwin.lib.darwinSystem;
      }
    )
  ];
}
