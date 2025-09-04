{
  pkgs,
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
