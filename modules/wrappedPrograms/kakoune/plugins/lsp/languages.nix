{
  flake.wrappers.kakoune =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.kak-lsp;
    in
    {
      config.runtimePkgs = lib.mapAttrsToList (name: server: server.package) cfg.languageServers;

      config.constructFiles =
        let
          perLangConfig =
            lang:
            let
              toml = pkgs.formats.toml { };
              serversToml = toml.generate "kak-lsp-${lang}.toml" (
                lib.pipe cfg.languageServers [
                  (lib.filterAttrs (_: server: builtins.elem lang server.filetypes))
                  (lib.mapAttrs (name: server: server.settings))
                ]
              );
              lang-id =
                if builtins.hasAttr lang cfg.languageIDs then
                  ''
                    set-option buffer lsp_language_id ${cfg.languageIDs.${lang}}
                  ''
                else
                  "# No lang-id remap needed";
              langExtras = cfg.languageExtras."${lang}" or { };
            in
            {
              name = "${lang}.kak";
              value = {
                relPath = "share/kak/autoload/plugins/kak-lsp/${lang}.kak";
                content = ''
                  provide-module kak-lsp-${lang} %{
                    # LSP Configuration for ${lang}
                    hook -group lsp-filetype-${lang} global WinSetOption filetype=(?:${lang}) %{
                      set-option buffer lsp_servers %{
                        ${builtins.readFile serversToml}
                      }
                      ${lang-id}
                      ${
                        if langExtras.formatOnSave or true then
                          ''
                            # Format the document if possible
                            hook window -group lsp-formatting BufWritePre .* %{ lsp-formatting-sync }
                          ''
                        else
                          ""
                      }
                      ${
                        if langExtras.semanticTokens or true then
                          ''
                            # Semantic tokens
                            hook window -group semantic-tokens BufReload .* lsp-semantic-tokens
                            hook window -group semantic-tokens NormalIdle .* lsp-semantic-tokens
                            hook window -group semantic-tokens InsertIdle .* lsp-semantic-tokens
                            hook -once -always window WinSetOption filetype=.* %{
                              remove-hooks window semantic-tokens
                            }
                          ''
                        else
                          ""
                      }
                      ${
                        if langExtras.inlayHints or true then
                          ''
                            # Enable inlay hints
                            lsp-inlay-hints-enable window
                          ''
                        else
                          ""
                      }
                    }
                  }
                '';
              };
            };
          a = lib.mapAttrsToList (_: server: server.filetypes) cfg.languageServers;
        in
        lib.pipe a [
          # (lib.mapAttrsToList (_: server: server.filetypes))
          lib.flatten
          lib.unique
          (map perLangConfig)
          builtins.listToAttrs
        ];
    };
}
