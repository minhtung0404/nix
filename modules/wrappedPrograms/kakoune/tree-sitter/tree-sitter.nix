{
  flake.wrappers.kak-tree-sitter =
    {
      config,
      pkgs,
      lib,
      wlib,
      ...
    }:
    let
      mkGrammarPackage =
        {
          name,
          src,
          grammarPath ? "src",
          grammarCompileArgs ? [
            "-O3"
            "-c"
            "-fpic"
            "../parser.c"
            "../scanner.c"
            "-I"
            ".."
          ],
          grammarLinkArgs ? [
            "-shared"
            "-fpic"
            "parser.o"
            "scanner.o"
          ],
        }:
        pkgs.stdenv.mkDerivation {
          inherit src;
          name = "kak-tree-sitter-grammar-${name}.so";
          version = "latest";
          buildPhase = ''
            mkdir ${grammarPath}/build
            cd ${grammarPath}/build
            $CC ${lib.concatStringsSep " " grammarCompileArgs}
            $CC ${lib.concatStringsSep " " grammarLinkArgs} -o ${name}.so
          '';
          installPhase = ''
            cp ${name}.so $out
          '';
        };

    in
    {

      imports = [ wlib.modules.default ];

      config =
        let
          allGroups = lib.attrsets.recursiveUpdate config.highlighterGroups config.extraHighlighterGroups;

          aliases = lib.attrsets.recursiveUpdate config.faceAliases config.extraAliases;

          toScm = name: lib.strings.concatStringsSep "." (lib.strings.splitString "_" name);

          toGrammarConf =
            name: lang: with lang; {
              source.local.path = mkGrammarPackage {
                inherit name;
                src = grammar.src;
                grammarPath = grammar.path;
                grammarCompileArgs = grammar.compile.flags ++ grammar.compile.args;
                grammarLinkArgs = grammar.link.flags ++ grammar.link.args;
              };
              compile = grammar.compile.command;
              compile_args = grammar.compile.args;
              compile_flags = grammar.compile.flags;
              link = grammar.link.command;
              link_args = grammar.link.args ++ [
                "-o"
                "${name}.so"
              ];
              link_flags = grammar.link.flags;
            };

          toLanguageConf =
            name: lang:
            (removeAttrs lang [
              "grammar"
              "queries"
            ])
            // (with lang; {
              queries = rec {
                path = if queries.path == null then "runtime/queries/${name}" else queries.path;
                source.local.path = "${queries.src}/${path}";
              };
            });

          toTs = name: "ts_${lib.strings.concatStringsSep "_" (lib.strings.splitString "." name)}";

          definedFaces = lib.mapAttrs' (name: value: lib.nameValuePair (toTs name) value) allGroups;
          aliasFaces = lib.mapAttrs' (name: value: lib.nameValuePair (toTs name) "@${toTs value}") aliases;

          faces = definedFaces // aliasFaces;

        in
        {
          package = pkgs.kak-tree-sitter-unwrapped;

          flags."--config" = config.constructFiles."config.toml".path;
          suffixVar = [
            [
              "PATH"
              ":"
              "${lib.makeBinPath [ pkgs.gcc ]}"
            ]
          ];

          binName = "ktsctl";
          exePath = "bin/ktsctl";

          constructFiles."config.toml" = {
            relPath = "config.toml";
            builder = ''
              ${pkgs.remarshal}/bin/json2toml "$1" "$2"
            '';
          };

          constructFiles."config.toml" = {
            content = builtins.toJSON {
              highlight.groups = builtins.sort (a: b: a < b) (
                map toScm (builtins.attrNames allGroups ++ builtins.attrNames aliases)
              );
              language = builtins.mapAttrs toLanguageConf config.languages;
              grammar = builtins.mapAttrs toGrammarConf config.languages;
            };
          };

          constructFiles."kak-tree-sitter" = {
            relPath = "ts.kak";
            content = ''
              # Enable kak-tree-sitter
              eval %sh{kak-tree-sitter -kds --init $kak_session --config ${
                config.constructFiles."config.toml".path
              }}
              map global normal <c-t> ": enter-user-mode tree-sitter<ret>"
              ${lib.concatStringsSep "\n" (
                builtins.attrValues (builtins.mapAttrs (name: face: "  face global ${name} \"${face}\"") faces)
              )}
            '';
          };

        };
    };
}
