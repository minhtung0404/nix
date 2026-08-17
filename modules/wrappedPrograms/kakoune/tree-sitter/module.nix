{
  flake.wrappers.kak-tree-sitter =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      languageModule = lib.types.submodule {
        options = {
          # Grammar
          grammar.src = lib.mkOption {
            type = lib.types.package;
            description = "The repo to be used";
          };
          grammar.path = lib.mkOption {
            type = lib.types.str;
            default = "src";
          };
          grammar.compile = {
            command = lib.mkOption {
              type = lib.types.str;
              default = "${pkgs.gcc}/bin/gcc";
            };
            args = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [
                "-c"
                "-fpic"
                "../parser.c"
                "../scanner.c"
                "-I"
                ".."
              ];
            };
            flags = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ "-O3" ];
            };
          };
          grammar.link = {
            command = lib.mkOption {
              type = lib.types.str;
              default = "${pkgs.gcc}/bin/gcc";
            };
            args = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [
                "-shared"
                "-fpic"
                "parser.o"
                "scanner.o"
              ];
            };
            flags = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ "-O3" ];
            };
          };
          # Queries
          queries.src = lib.mkOption {
            type = lib.types.package;
            description = "The repo to be used";
          };
          queries.path = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
          };
          # Other options
          remove_default_highlighter = lib.mkOption {
            type = lib.types.bool;
            default = true;
          };
          filetype_hook = lib.mkOption {
            type = lib.types.bool;
            default = true;
          };
          faceAliases = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
          };
        };
      };
    in
    {

      options = {
        highlighterGroups = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          default = { };
        };

        extraHighlighterGroups = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          default = { };
          description = "Highlighter groups to add to the `highlighterGroups`. Maps from group names to face names.";
        };

        faceAliases = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          default = {
            comment_block = "comment";
            comment_line = "comment";
            constant_character_escape = "constant_character";
            constant_numeric_float = "constant_numeric";
            constant_numeric_integer = "constant_numeric";
            function_method = "function";
            function_special = "function";
            keyword_control = "keyword";
            keyword_control_repeat = "keyword";
            keyword_control_return = "keyword";
            keyword_control_except = "keyword";
            keyword_control_exception = "keyword";
            keyword_function = "keyword";
            keyword_operator = "keyword";
            keyword_special = "keyword";
            keyword_storage = "keyword";
            keyword_storage_modifier = "keyword";
            keyword_storage_modifier_mut = "keyword";
            keyword_storage_modifier_ref = "keyword";
            keyword_storage_type = "keyword";
            punctuation_bracket = "punctuation";
            punctuation_delimiter = "punctuation";
            text = "string";
            type_builtin = "type";
          };
          description = "Highlighter groups to be aliased by other groups";
        };

        extraAliases = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          default = { };
          description = "Extra highlighter groups to be aliased by other groups";
        };

        languages = lib.mkOption {
          type = lib.types.attrsOf languageModule;
          default = { };
        };
      };
    };
}
