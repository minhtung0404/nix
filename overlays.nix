{ nixpkgs, ... }@inputs:
let
  nki-source = inputs.nki-nix-home.sourceInfo.outPath;
  overlay-versioning = final: prev: {
  };

  overlay-libs = final: prev: { libs.crane = inputs.crane.mkLib final; };
  overlay-packages = final: prev: {
    kak-tree-sitter = final.callPackage "${nki-source}/packages/common/kak-tree-sitter" { };

    kak-lsp = final.rustPlatform.buildRustPackage {
      name = "kak-lsp";
      src = inputs.nki-nix-home.inputs.kak-lsp;
      cargoLock.lockFile = "${inputs.nki-nix-home.inputs.kak-lsp}/Cargo.lock";
      buildInputs = [ final.libiconv ];

      meta.mainProgram = "kak-lsp";
    };
  };
in
[
  overlay-versioning
  overlay-libs
  overlay-packages
  inputs.nki-nix-home.overlays.kakoune
  inputs.nur.overlays.default
]
