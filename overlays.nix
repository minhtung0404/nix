{ nixpkgs, ... }@inputs:
let
  overlay-versioning = final: prev: {
    kakoune-unwrapped = prev.kakoune-unwrapped.overrideAttrs (attrs: {
      version = "r${builtins.substring 0 6 inputs.kakoune.rev}";
      src = inputs.kakoune;
      patches = [
        # patches in the original package was already applied
      ];
    });
  };

  overlay-libs = final: prev: { libs.crane = inputs.crane.mkLib final; };
  overlay-packages = final: prev: {
    kak-tree-sitter = final.callPackage ./packages/common/kak-tree-sitter.nix {
      rustPlatform = final.unstable.rustPlatform;
    };

    kak-lsp = let
      src = inputs.kak-lsp;
      cargoArtifacts = final.libs.crane.buildDepsOnly { inherit src; };
    in final.libs.crane.buildPackage {
      inherit src cargoArtifacts;
      buildInputs = (with final;
        lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
          Security
          SystemConfiguration
          CoreServices
        ])) ++ (with final; [ libiconv ]);
    };
  };
in [
  overlay-libs
  overlay-packages
  # Bug fixes
] # we assign the overlay created before to the overlays of nixpkgs.

