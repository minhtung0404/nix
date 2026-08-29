{
  flake.wrappers.kakoune =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      config =
        let
          helix-src = pkgs.fetchFromGitHub {
            owner = "helix-editor";
            repo = "helix";
            rev = "25.07.1";
            hash = "sha256-RFSzGAcB0mMg/02ykYfTWXzQjLFu2CJ4BkS5HZ/6pBo=";
          };

          cfg = config.kak-tree-sitter;
          allGroups = lib.attrsets.recursiveUpdate cfg.highlighterGroups cfg.extraHighlighterGroups;

          aliases = lib.attrsets.recursiveUpdate cfg.faceAliases cfg.extraAliases;

          toScm = name: lib.strings.concatStringsSep "." (lib.strings.splitString "_" name);

          toGrammarConf = name: lang: {
            source.local.path = "${lang.package}/parser";
          };

          toLanguageConf = name: lang: {
            queries.source.local.path =
              if lang.helixSrc == null then
                "${lang.package}/queries"
              else
                "${helix-src}/runtime/queries/${lang.helixSrc}";
          };

          toTs = name: "ts_${lib.strings.concatStringsSep "_" (lib.strings.splitString "." name)}";

          definedFaces = lib.mapAttrs' (name: value: lib.nameValuePair (toTs name) value) allGroups;
          aliasFaces = lib.mapAttrs' (name: value: lib.nameValuePair (toTs name) "@${toTs value}") aliases;

          faces = definedFaces // aliasFaces;

        in
        {
          plugins.kak-tree-sitter = {
            src = "${config.kak-tree-sitter.package}/kak-tree-sitter";
            activationScript = ''
              require-module kak-tree-sitter
            '';
          };

          runtimePkgs = [ cfg.package ];

          constructFiles."kak-tree-sitter.toml" = {
            relPath = "share/kak/autoload/plugins/kak-tree-sitter/kak-tree-sitter.toml";
            builder = ''
              ${pkgs.remarshal}/bin/json2toml "$1" "$2"
            '';
            content = builtins.toJSON {
              highlight.groups = builtins.sort (a: b: a < b) (
                map toScm (builtins.attrNames allGroups ++ builtins.attrNames aliases)
              );
              features = {
                highlighting = true;
                text_objects = true;
              };
              language = builtins.mapAttrs toLanguageConf cfg.languages;
              grammar = builtins.mapAttrs toGrammarConf cfg.languages;
            };
          };

          constructFiles."kak-tree-sitter.kak" = {
            relPath = "share/kak/autoload/plugins/kak-tree-sitter/kak-tree-sitter.kak";
            content = ''
              provide-module kak-tree-sitter %◍
                # Enable kak-tree-sitter
                eval %sh{kak-tree-sitter -kds -vvv --init $kak_session --config ${
                  config.constructFiles."kak-tree-sitter.toml".path
                }}
                map global normal <c-t> ": enter-user-mode tree-sitter<ret>"
                ${lib.concatStringsSep "\n" (
                  builtins.attrValues (builtins.mapAttrs (name: face: "  face global ${name} \"${face}\"") faces)
                )}
              ◍
            '';
          };
        };
    };
}
