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
  cfg = config.mtn.services.my-caddy;
  username = config.mtn.username;

  caddyfile = pkgs.writeText "Caddyfile" ''
    https://mtn-m1.dtth.ts:8080 {
      tls internal
      reverse_proxy localhost:25600
    }
  '';
in
{
  options.mtn.services.my-caddy = {
    enable = mkEnableOption "My Caddy";

    package = mkPackageOption pkgs "caddy" { };

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
    launchd.agents.caddy = {
      enable = true;
      config = {
        EnvironmentVariables = {
        };
        ProcessType = "Interactive";
        ProgramArguments = [
          "${cfg.package}/bin/caddy"
          "run"
          "--config"
          "${caddyfile}"
          "--adapter"
          "caddyfile"
        ];
        KeepAlive = true;
        RunAtLoad = true;
        StandardOutPath = "/tmp/${username}/caddy.out.log";
        StandardErrorPath = "/tmp/${username}/caddy.err.log";
      };
    };
  };
}
