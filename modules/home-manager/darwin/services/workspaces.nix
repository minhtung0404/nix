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
  options.mtn = {
    workspaces = lib.mkOption {
      type = lib.types.listOf workspaceType;
      default = [ ];
      example = lib.litteralExpression "[ ]";
      description = ''
        List of workspace for Sketchybar + Aerospace
      '';
    };
  };
}
