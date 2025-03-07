{ config, lib, pkgs, ... }:

let
  inherit (lib)
    literalExpression maintainers mkEnableOption mkIf mkPackageOption mkOption
    optionals types;
  cfg = config.minhtung0404.services.sketchybar;
in {
  options.minhtung0404.services.sketchybar = {
    enable = mkEnableOption "sketchybar";

    package = mkPackageOption pkgs "sketchybar" { };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      example = literalExpression "[ pkgs.jq ]";
      description = ''
        Extra packages to add to PATH.
      '';
    };
  };

  config.minhtung0404.services.sketchybar = {
    extraPackages = [ pkgs.lua5_4_compat pkgs.aerospace pkgs.nowplaying-cli ];
  };

  config.launchd.user.agents.sketchybar = {
    path = [ cfg.package ] ++ cfg.extraPackages
      ++ [ config.environment.systemPath ];
    serviceConfig = {
      ProgramArguments = [ "${cfg.package}/bin/sketchybar" ]
        ++ [ "--config" (builtins.toString ./config/sketchybarrc) ];
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = "/tmp/sbar.log";
      StandardErrorPath = "/tmp/sbar_err.log";
    };
  };
}
