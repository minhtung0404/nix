{ inputs, ... }: {
  imports = [
    inputs.flake-file.flakeModules.dendritic
  ];

  flake-file.inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
  };

}
