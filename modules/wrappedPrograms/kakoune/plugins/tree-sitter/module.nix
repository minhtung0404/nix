{
  flake.wrappers.kakoune =
    {
      lib,
      pkgs,
      ...
    }:
    {
      options.kak-tree-sitter = {
        package = lib.mkOption {
          type = lib.types.package;
          default = pkgs.kak-tree-sitter;
        };

        src = lib.mkOption {
          type = lib.types.attrsOf lib.types.package;
          default = { };
        };

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
          type = lib.types.attrsOf (
            lib.types.submodule (
              { config, ... }: {
                options = {
                  package = lib.mkOption {
                    type = lib.types.package;
                    description = "The tree-sitter package";
                  };
                  queries.src = lib.mkOption {
                    type = lib.types.package;
                    default = config.package;
                    description = "The repo to use";
                  };
                  queries.path = lib.mkOption {
                    type = lib.types.str;
                    description = "Path to the queries";
                    default = "queries";
                  };
                };
              }
            )
          );
          default = { };
        };
      };
    };
}
