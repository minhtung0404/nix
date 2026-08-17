{
  flake.wrappers.kakoune =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config.plugins.peneira = {
        src = pkgs.fetchFromGitHub {
          owner = "gustavo-hms";
          repo = "peneira";
          rev = "b56dd10bb4771da327b05a9071b3ee9a092f9788";
          sha256 = "sha256-rZBZ+ks9aaefmjl6GAAwg/HQqDbMEp+zkevMbJ1QeUI=";
        };
        activationScript = ''
          require-module peneira

          # Change selection color
          set-face global PeneiraSelected @PrimarySelection

          # Buffers list
          define-command -hidden peneira-buffers %{
              peneira 'buffers: ' %{ printf '%s\n' $kak_quoted_buflist } %{
                  buffer %arg{1}
              }
          }

          set-option global peneira_files_command "${pkgs.fd}/bin/fd -L ."

          # Grep in the current location
          define-command peneira-grep %{
            peneira 'line: ' %{ ${pkgs.ripgrep}/bin/rg -L -n . . } %{
              lua %arg{1} %{
                local file, line = arg[1]:match("([^:]+):(%d+):")
                kak.edit(file, line)
              }
            }
          }

          # A peneira menu
          declare-user-mode fuzzy-match-menu

          map -docstring "Switch to buffer"                            global fuzzy-match-menu b ": peneira-buffers<ret>"
          map -docstring "Symbols"                                     global fuzzy-match-menu s ": peneira-symbols<ret>"
          map -docstring "Lines"                                       global fuzzy-match-menu l ": peneira-lines<ret>"
          map -docstring "Lines in the current directory"              global fuzzy-match-menu g ": peneira-grep<ret>"
          map -docstring "Files in project"                            global fuzzy-match-menu f ": peneira-files<ret>"
          map -docstring "Files in currently opening file's directory" global fuzzy-match-menu F ": peneira-local-files<ret>"

          # Bind menu to user mode
          map -docstring "Fuzzy matching" global user f ": enter-user-mode fuzzy-match-menu<ret>"
        '';
      };
    };
}
