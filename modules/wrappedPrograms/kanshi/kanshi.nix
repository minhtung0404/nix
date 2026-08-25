{ self, ... }: {
  flake.wrappers.kanshi =
    {
      config,
      lib,
      wlib,
      pkgs,
      ...
    }:
    {
      imports = [
        wlib.modules.default
        self.modules.generic.workspaces
      ];

      options =
        let
          outputType = lib.types.submodule {
            options = {
              enable = lib.mkEnableOption "monitor";
              scale = lib.mkOption {
                type = lib.types.nullOr lib.types.number;
              };
              position.x = lib.mkOption {
                type = lib.types.nullOr lib.types.number;
              };
              position.y = lib.mkOption {
                type = lib.types.nullOr lib.types.number;
              };
              variable-refresh-rate = lib.mkOption {
                type = lib.types.bool;
                default = false;
              };
              alias = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
              };
            };
          };
        in
        {
          monitorOutputs = lib.mkOption {
            type = lib.types.attrsOf outputType;
            default = { };
            description = "Monitor arrangement";
          };

          profile = lib.mkOption {
            type = lib.types.attrsOf (
              lib.types.submodule {
                options = {
                  output = lib.mkOption {
                    type = lib.types.attrsOf outputType;
                    default = { };
                  };
                  main = lib.mkOption {
                    type = lib.types.str;
                  };
                  secondary = lib.mkOption {
                    type = lib.types.str;
                  };
                  exec = lib.mkOption {
                    type = lib.types.nullOr lib.types.str;
                    default = null;
                  };
                };
              }
            );
          };
        };

      config =
        let
          outputToKdl = name: value: {
            output = _: {
              props = [ name ];
              content =
                (
                  if value.enable then
                    {
                      enable = _: { };
                    }
                  else
                    {
                      disable = _: { };
                    }
                )
                // (
                  if (value.scale != null) then
                    {
                      scale = value.scale;
                    }
                  else
                    { }
                )
                // (
                  if (value.position.x != null) then
                    {
                      position = lib.concatStringsSep "," [
                        (toString value.position.x)
                        (toString value.position.y)
                      ];
                    }
                  else
                    { }
                )
                // (
                  if value.variable-refresh-rate then
                    {
                      adaptive_sync = _: { };
                    }
                  else
                    { }
                )
                // (
                  if (value.alias != null) then
                    {
                      alias = "\$${value.alias}";
                    }
                  else
                    { }
                );
            };
          };
        in
        {
          package = pkgs.kanshi;
          flags = {
            "--config" = config.constructFiles.generatedConfig.path;
          };
          constructFiles.moveWorkspaceToMonitor =
            let
              rev = lib.lists.reverseList config.mtn.workspaces;
            in
            {
              relPath = "move-workspace-to-monitor.sh";
              content = lib.concatStrings (
                builtins.concatLists [
                  (map (
                    w:
                    "niri msg action move-workspace-to-monitor --reference \"${"${w.id} - ${w.name}"}\" ${
                      if w.monitor == "secondary" then "\"$2\"" else "\"$1\""
                    }\n"
                  ) rev)
                  (map (
                    w: "niri msg action move-workspace-to-index 1 --reference \"${"${w.id} - ${w.name}"}\"\n"
                  ) rev)
                ]
              );
            };
          constructFiles.generatedConfig = {
            relPath = "${config.binName}-config.kdl";
            content = wlib.toKdl (_: {
              lvl = 0;
              indent = "  ";
              version = 2;
              content = builtins.concatLists [
                (lib.mapAttrsToList outputToKdl config.monitorOutputs)
                (lib.mapAttrsToList (name: value: {
                  profile = _: {
                    props = [ name ];
                    content = builtins.concatLists [
                      (lib.mapAttrsToList outputToKdl value.output)
                      [
                        {
                          exec = [
                            (lib.getExe pkgs.bash)
                            config.constructFiles.moveWorkspaceToMonitor.path
                            value.main
                            value.secondary
                          ];
                        }
                      ]
                    ];
                  };
                }) config.profile)
              ];
            });
          };
        };
    };
}
