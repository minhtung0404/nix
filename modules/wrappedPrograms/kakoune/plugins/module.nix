{
  flake.wrappers.kakoune = { config, lib, ... }: {
    options.plugins = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            src = lib.mkOption {
              type = lib.types.path;
            };

            activationScript = lib.mkOption {
              type = lib.types.nullOr lib.types.lines;
              default = null;
            };

            wrapAsModule = lib.mkOption {
              type = lib.types.bool;
              default = false;
            };
          };
        }
      );

      default = { };
    };

    config = {
      buildCommand = lib.mapAttrs (
        name: plugin:
        let
          folder = "${placeholder config.outputName}/share/kak/autoload/plugins/${name}";
        in
        {
          after = [ "symlinkScript" ];
          data = ''
            mkdir -p ${lib.escapeShellArg folder}
            for file in ${lib.escapeShellArg "${plugin.src}"}/*; do
              ln -s "$file" ${lib.escapeShellArg folder}
            done
          '';
        }
      ) (lib.filterAttrs (name: plugin: !plugin.wrapAsModule) config.plugins);

      constructFiles =
        (lib.mapAttrs' (
          name: plugin:
          lib.nameValuePair "${name}-on-load" {
            relPath = "share/kak/on-load/${name}.kak";
            content = plugin.activationScript;
          }
        ) (lib.filterAttrs (name: plugin: plugin.activationScript != null) config.plugins))
        // (lib.mapAttrs' (
          name: plugin:
          lib.nameValuePair "${name}" {
            relPath = "share/kak/autoload/plugins/${name}/${name}.kak";
            content = ''
              provide-module ${name} %◍
                ${builtins.readFile plugin.src}
              ◍
            '';
          }
        ) (lib.filterAttrs (name: plugin: plugin.wrapAsModule) config.plugins));
    };
  };
}
