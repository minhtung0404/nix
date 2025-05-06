{ nixpkgs, ... }@inputs:
let
  overlay-versioning = final: prev: {
  };

  overlay-libs = final: prev: { libs.crane = inputs.crane.mkLib final; };
  overlay-packages = final: prev: {
    kak-tree-sitter = final.callPackage ./packages/common/kak-tree-sitter.nix { };

    kak-lsp = final.rustPlatform.buildRustPackage {
      name = "kak-lsp";
      src = inputs.nki-nix-home.inputs.kak-lsp;
      cargoLock.lockFile = "${inputs.nki-nix-home.inputs.kak-lsp}/Cargo.lock";
      buildInputs = [ final.libiconv ];

      meta.mainProgram = "kak-lsp";
    };

    mtn-kakoune = final.callPackage ./packages/common/mtn-kakoune { };
  };
in
[
  overlay-versioning
  overlay-libs
  overlay-packages
  inputs.nki-nix-home.overlays.kakoune
  # Bug fixes
] # we assign the overlay created before to the overlays of nixpkgs.
