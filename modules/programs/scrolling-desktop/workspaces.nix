{
  flake.modules.generic.workspaces =
    {
      config,
      lib,
      ...
    }:
    let
      workspaceType = lib.types.submodule {
        options = {
          id = lib.mkOption {
            type = lib.types.str;
            description = "Numeric workspace id";
          };

          name = lib.mkOption {
            type = lib.types.str;
            description = "Workspace name";
          };

          icon = lib.mkOption {
            type = lib.types.str;
            description = "Workspace icon";
          };

          monitor = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            description = "Workspace icon";
            default = null;
          };
        };
      };
    in
    {
      options.mtn.workspaces = lib.mkOption {
        type = lib.types.listOf workspaceType;
        default = [ ];
        example = lib.litteralExpression "[ ]";
        description = ''
          List of workspace for scrolling desktop
        '';
      };
      options.mtn.nameToWorkspace = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        example = lib.litteralExpression "{ }";
        description = ''
          Map from workspace name to workspace id
        '';
      };

      config.mtn.workspaces = [
        {
          id = "1";
          name = "web";
          icon = "🌐";
        }
        {
          id = "2";
          name = "work";
          icon = "💻";
        }
        {
          id = "3";
          name = "notes";
          icon = "📝";

        }
        {
          id = "4";
          name = "mail";
          icon = "📩";

        }
        {
          id = "5";
          name = "chat";
          icon = "💬";
          monitor = "secondary";

        }
        {
          id = "6";
          name = "games";
          icon = "🎮";
        }
        {
          id = "7";
          name = "other";
          icon = "🔣";
          monitor = "secondary";
        }
      ];
      config.mtn.nameToWorkspace = lib.listToAttrs (
        map (s: {
          name = s.name;
          value = s.id;
        }) config.mtn.workspaces
      );
    };
}
