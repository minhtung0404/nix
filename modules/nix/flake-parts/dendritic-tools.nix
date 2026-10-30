{ inputs, ... }: {
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
  };

  systems = [
    "x86_64-linux"
    "aarch64-darwin"
  ];
}
