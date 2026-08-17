{
  flake.wrappers.kakoune =
    {
      config,
      pkgs,
      lib,
      wlib,
      ...
    }:
    let
      cfg = config.kak-lsp;
    in
    {
      options.kak-lsp = {
        package = lib.mkOption {
          type = lib.types.package;
          default = pkgs.kakoune-lsp;
        };
        languageIDs = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          default = { };
          description = "Map from language to ID";
        };
        languageServers = lib.mkOption {
          type = lib.types.attrsOf (
            lib.types.submodule {
              options = {
                package = lib.mkOption {
                  type = lib.types.package;
                  description = "Package for LSP";
                };
                filetypes = lib.mkOption {
                  type = lib.types.listOf lib.types.str;
                  description = "Filetype for LSP";
                };
                settings = lib.mkOption {
                  type = lib.types.attrsOf lib.types.unspecified;
                  description = "Filetype for LSP";
                };
              };
            }
          );
        };

        faces = lib.mkOption {
          type = lib.types.listOf (
            lib.types.submodule {
              face = lib.mkOption {
                type = lib.types.str;
              };
              token = lib.mkOption {
                type = lib.types.str;
              };
              modifier = lib.mkOption {
                type = lib.types.nullOr (lib.types.listOf lib.types.str);
                default = null;
              };
            }
          );
        };
      };

      config.kak-lsp.languageIDs = {
        c = "c_cpp";
        cpp = "c_cpp";
        javascript = "javascriptreact";
        protobuf = "proto";
        sh = "shellscript";
      };

      config.constructFiles."kak-lsp.kak" =
        let
          mapFace =
            face:
            let
              modifiers = if face.modifier == null then "" else ", modifiers=${builtins.toJSON face.modifiers}";
            in
            "{face=${builtins.toJSON face.face}, token=${builtins.toJSON face.token}${modifiers}}";
          faces = lib.concatMapStringsSep ",\n    " mapFace cfg.faces;
        in
        {
          relPath = "share/kak/autoload/plugins/kak-lsp/kak-lsp.kak";
          content = ''
            provide-module kak-lsp %{
              eval %sh{kak-lsp}
              remove-hooks global lsp-filetype-.*


              lsp-enable
              map global lsp N -docstring "Display the next message request" ": lsp-show-message-request-next<ret>"
              map global normal <c-l> ": enter-user-mode lsp<ret>"
              map global normal <c-h> ": lsp-hover<ret>"
              map global normal <c-s-h> ": lsp-hover-buffer<ret>"
              # lsp-auto-hover-insert-mode-enable
              set global lsp_hover_anchor true
              map global insert <tab> '<a-;>:try lsp-snippets-select-next-placeholders catch %{ execute-keys -with-hooks <lt>tab> }<ret>' -docstring 'Select next snippet placeholder'
              map global object a '<a-semicolon>lsp-object<ret>' -docstring 'LSP any symbol'
              map global object <a-a> '<a-semicolon>lsp-object<ret>' -docstring 'LSP any symbol'
              map global object f '<a-semicolon>lsp-object Function Method<ret>' -docstring 'LSP function or method'
              map global object t '<a-semicolon>lsp-object Class Interface Struct<ret>' -docstring 'LSP class interface or struct'
              map global object d '<a-semicolon>lsp-diagnostic-object --include-warnings<ret>' -docstring 'LSP errors and warnings'
              map global object D '<a-semicolon>lsp-diagnostic-object<ret>' -docstring 'LSP errors'
              set-option global modelinefmt "%opt{lsp_modeline} %opt{modelinefmt}"

              map global goto d <esc>:lsp-definition<ret> -docstring 'LSP definition'
              map global goto r <esc>:lsp-references<ret> -docstring 'LSP references'
              map global goto y <esc>:lsp-type-definition<ret> -docstring 'LSP type definition'

              ## Require LSP
              ${lib.pipe cfg.languageServers [
                (lib.mapAttrsToList (_: server: server.filetypes))
                lib.flatten
                lib.unique
                (builtins.map (lang: "require-module kak-lsp-${lang}"))
                (lib.concatStringsSep "\n")
              ]}
              ## Faces
              set-face global InlayHint "+bd@type"
              set-option global lsp_semantic_tokens %{
                [
                  ${faces}
                ]
              }
            }

          '';
        };
    };
}
