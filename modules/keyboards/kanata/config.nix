{ config, pkgs, lib, environment, ... }:
let
  inherit (lib)
    mkIf mkEnableOption mkPackageOption mkOption types literalExpression;
  cfg = config.minhtung0404.services.kanata;
in {
  options.minhtung0404.services.kanata = {
    enable = mkEnableOption "kanata-with-cmd";

    package = mkPackageOption pkgs "kanata-with-cmd" { };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      example = literalExpression "[ pkgs.jq ]";
      description = ''
        Extra packages to add to PATH.
      '';
    };

    configFile = mkOption {
      type = types.listOf types.package;
      default = [ ];
      example = literalExpression "[ ~/.config/kanata/kanata.kbd ]";
      description = ''
        path to the config
      '';
    };
  };
}
