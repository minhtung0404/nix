{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    mkIf
    literalExpression
    types
    ;
  cfg = config.mtn.services.my-komga;
  username = config.mtn.username;
in
{
  options.mtn.services.my-komga = {
    enable = mkEnableOption "My Komga";

    package = mkPackageOption pkgs "komga" { };

    configDir = mkOption {
      type = types.str;
      default = "/Volumes/Data1/komga/.komga/";
      example = "~/.komga";
      description = ''
        Config directory for Komga
      '';
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [
      ];
      example = literalExpression "[ pkgs.jq ]";
      description = ''
        Extra packages to add to PATH.
      '';
    };
  };

  config = mkIf cfg.enable {
    launchd.agents.komga = {
      enable = true;
      config = {
        EnvironmentVariables = {
          KOMGA_CONFIGDIR = cfg.configDir;
        };
        ProcessType = "Interactive";
        ProgramArguments = [
          "${cfg.package}/bin/komga"
        ];
        KeepAlive = true;
        RunAtLoad = true;
        StandardOutPath = "/tmp/${username}/komga.out.log";
        StandardErrorPath = "/tmp/${username}/komga.err.log";
      };
    };
  };
}
