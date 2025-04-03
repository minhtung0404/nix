{
  callPackage,
  kakoune,
  kakoune-unwrapped,
  ...
}:
let
  lsp = callPackage ./lsp.nix { };
in
(kakoune.override {
  plugins = callPackage ./plugins.nix { } ++ [
    (callPackage ./my-scripts.nix { })
    (callPackage ./kaktex { })
    (callPackage ./faces.nix { })
    lsp.plugin
  ];
}).overrideAttrs
  (attrs: {
    buildCommand = ''
      ${attrs.buildCommand or ""}
      # location of kak binary is used to find ../share/kak/autoload,
      # unless explicitly overriden with KAKOUNE_RUNTIME
      rm "$out/bin/kak"
      makeWrapper "${kakoune-unwrapped}/bin/kak" "$out/bin/kak" \
        --set KAKOUNE_RUNTIME "$out/share/kak" \
        --suffix PATH ":" "${lsp.extraPaths}"
    '';
  })
