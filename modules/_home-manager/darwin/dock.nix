{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.mtn.programs.my-dock;
in
{
  options.mtn.programs.my-dock = {
    enable = lib.mkEnableOption "my-dock";
    apps = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = lib.literalExpression ''[ "apple" ]'';
      description = ''
        List of apps to pin to dock
      '';
    };
  };
  config.home.activation =
    let
      scripts = ''
        run --silence ${pkgs.dockutil}/bin/dockutil --remove all
        ${
          (lib.concatMapStrings (
            app: "run --silence ${pkgs.dockutil}/bin/dockutil --add \"${app}\"\n"
          ) cfg.apps)
        }
      '';
    in
    lib.mkIf cfg.enable {
      "persistent-apps" = lib.hm.dag.entryAfter [ "writeBoundary" ] (''
        ${scripts}
      '');
    };
}
