{ pkgs, ... }: {
  flake.wrappers.kanata =
    {
      config,
      wlib,
      lib,
      ...
    }:
    {
      imports = [ wlib.modules.default ];

      options = {
        configFile = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [
            "gm610_linux"
            "apple_linux"
          ];
          example = lib.literalExpression ''[ "apple" ]'';
          description = ''
            path to the config
          '';
        };

      };

      config = {
        package = config.pkgs.kanata-with-cmd;

        flags = {
          "-c" = map (name: config.constructFiles.${name}.path) config.configFile;
        };

        env = {
          OS = if config.pkgs.stdenv.isLinux then "linux" else "darwin";
        };

        constructFiles = builtins.listToAttrs (
          map (name: {
            name = name;
            value = {
              relPath = "${name}.kbd";
              content = ''
                ${builtins.readFile ./default_configs/${name}.kbd}
                ${builtins.readFile ./default_configs/common.kbd}
              '';
            };
          }) config.configFile
        );
      };
    };
}
