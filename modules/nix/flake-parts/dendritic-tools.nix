{ inputs, ... }: {
  imports = [
    inputs.flake-file.flakeModules.dendritic
    inputs.flake-parts.flakeModules.modules
  ];

  flake-file.inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-file.url = "github:vic/flake-file";
    import-tree.url = "github:vic/import-tree";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };
}
