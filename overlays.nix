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
    kak-tree-sitter = final.callPackage ./packages/common/kak-tree-sitter.nix { };

    kak-lsp =
      let
        src = inputs.kak-lsp;
        cargoArtifacts = final.libs.crane.buildDepsOnly { inherit src; };
      in
      final.libs.crane.buildPackage {
        inherit src cargoArtifacts;
        buildInputs =
          (
            with final;
            lib.optionals stdenv.isDarwin (
              with darwin.apple_sdk.frameworks;
              [
                Security
                SystemConfiguration
                CoreServices
              ]
            )
          )
          ++ (with final; [ libiconv ]);
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
