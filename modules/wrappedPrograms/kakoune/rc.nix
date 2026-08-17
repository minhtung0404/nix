{
  flake.wrappers.kakoune =
    {
      config,
      pkgs,
      wlib,
      lib,
      ...
    }:
    {
      options = {
        prependRc = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Content to prepend to the RC file.";
        };
        appendRc = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Content to append to the RC file.";
        };
      };

      config.constructFiles."kakrc.local" = {
        relPath = "share/kak/kakrc.local";
        content = ''
          ${config.prependRc}
          ${builtins.readFile ./kakrc}
          set global grepcmd "${pkgs.ripgrep}/bin/rg --line-number --no-column --no-heading --follow --color=never "
          ${config.appendRc}

          # Source any settings in the current working directory,
          # recursive upwards
          evaluate-commands %sh{
            # Exit if we're already in ~/.config/kak
            if [ "$(pwd)" = "$HOME/.config/kak" ]; then
              exit 0
            fi

            while true; do
              kakrc="$(pwd)/.kakrc"

              if [ -f "$kakrc" ]; then
                echo "source $kakrc"
              fi

              if [ "$(pwd)" = "/" ]; then
                exit 0
              fi

              cd ..
            done
          }
        '';
      };
    };
}
