{ lib, rustPlatform, fetchFromSourcehut, symlinkJoin, clang, git, writeText, ...
}:
let
  src = fetchFromSourcehut {
    owner = "~hadronized";
    repo = "kak-tree-sitter";
    rev = "kak-tree-sitter-v1.1.2";
    hash = "sha256-wBWfSyR8LGtug/mCD0bJ4lbdN3trIA/03AnCxZoEOSA=";
  };

  kak-tree-sitter = rustPlatform.buildRustPackage {
    inherit src;
    pname = "kak-tree-sitter";
    version = "1.1.2";
    cargoHash = "sha256-ukWUCHhbAtqzBRtILM2U3m0VCsPXGuKWsT/2e87dBHA=";
    cargoBuildOptions = [ "--package" "kak-tree-sitter" "--package" "ktsctl" ];
    useFetchCargoVendor = true;

    nativeBuildInputs = [ clang git ];

    patches = [
      # Allow absolute-path style repos
      (writeText "resources.patch" ''
        diff --git a/ktsctl/src/resources.rs b/ktsctl/src/resources.rs
        index f1da3ff..ac89345 100644
        --- a/ktsctl/src/resources.rs
        +++ b/ktsctl/src/resources.rs
        @@ -48,7 +48,8 @@ impl Resources {
               url
                 .trim_start_matches("http")
                 .trim_start_matches('s')
        -        .trim_start_matches("://"),
        +        .trim_start_matches(":/")
        +        .trim_start_matches("/"),
             );

             self.runtime_dir.join("sources").join(url_dir)
      '')
    ];
  };
in kak-tree-sitter

