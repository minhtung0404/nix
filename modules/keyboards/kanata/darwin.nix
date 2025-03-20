{ config, pkgs, lib, ... }:
with lib;

let
  appleConfigFile = pkgs.writeTextFile {
    name = "kanata_apple.kbd";
    text = pkgs.lib.strings.concatStrings [
      (builtins.readFile ./default_configs/apple.kbd)
      (builtins.readFile ./default_configs/common.kbd)
    ];
  };
  gm610ConfigFile = pkgs.writeTextFile {
    name = "kanata_gm610.kbd";
    text = pkgs.lib.strings.concatStrings [
      (builtins.readFile ./default_configs/gm610.kbd)
      (builtins.readFile ./default_configs/common.kbd)
    ];
  };
  inherit (lib)
    mkIf mkEnableOption mkPackageOption mkOption types literalExpression;
  cfg = config.minhtung0404.services.kanata;
in {
  imports = [ ./darwin_common.nix ];

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

  config.minhtung0404.services.kanata = {
    enable = true;
    configFile = [ appleConfigFile gm610ConfigFile ];
  };

}
