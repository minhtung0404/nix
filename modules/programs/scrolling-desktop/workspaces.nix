{
  flake.modules.generic.workspaces =
    {
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
          List of workspace for Sketchybar + Aerospace
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
    };
}
