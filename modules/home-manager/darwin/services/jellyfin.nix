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
  cfg = config.mtn.services.my-jellyfin;
  username = config.mtn.username;
in
{
  options.mtn.services.my-jellyfin = {
    enable = mkEnableOption "My Jellyfin";

    package = mkPackageOption pkgs "jellyfin" { };

    configDir = mkOption {
      type = types.str;
      default = "/Volumes/Data1/jellyfin/.jellyfin/";
      example = "~/.jellyfin";
      description = ''
        Config directory for Jellyfin
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
    launchd.agents.jellyfin = {
      enable = true;
      config = {
        EnvironmentVariables = {
        };
        ProcessType = "Interactive";
        ProgramArguments = [
          "${cfg.package}/bin/jellyfin"
          "--datadir"
          "/Volumes/Data2/jellyfin/"
          "--cachedir"
          "/Volumes/Data2/jellyfin/"
          "--configdir"
          "/Volumes/Data2/jellyfin/"
        ];
        KeepAlive = true;
        RunAtLoad = true;
        StandardOutPath = "/tmp/${username}/jellyfin.out.log";
        StandardErrorPath = "/tmp/${username}/jellyfin.err.log";
      };
    };
  };
}
