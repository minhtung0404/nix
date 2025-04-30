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

    myCustomPackage = prev.hello.overrideAttrs (old: {
      pname = "my-custom-hello";
      meta = old.meta // {
        mainProgram = "hello";
        description = "A custom version of Hello package";
      }; # Fix: Explicitly define mainProgram
      postInstall =
        old.postInstall or ""
        + ''
          ln -s $out/bin/hello $out/bin/my-custom-hello  # Ensure binary is accessible with new name
        '';
    });

    nki-kakoune = inputs.nki-nix-home.packages.kakoune;

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
