{ config, lib, pkgs, ... }:

let
  inherit (lib)
    literalExpression maintainers mkEnableOption mkIf mkPackageOption mkOption
    optionals types;
  cfg = config.minhtung0404.services.sketchybar;
  sketchybarconf = pkgs.runCommandCC "sketchybar-config" { } ''
    echo Creating sketchybar config
    mkdir $out

    cp -r ${./config}/* $out/
    mkdir $out/images
    cp ${../../../images/amira_squared.jpeg} $out/images/amira_squared.jpeg
    chmod -R 777 $out/helpers

    # helpers
    cd $out/helpers

    make
  '';
  username = builtins.exec "whoami";
in {
  options.minhtung0404.services.sketchybar = {
    package = mkPackageOption pkgs "sketchybar" { };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [ pkgs.lua5_4_compat pkgs.aerospace pkgs.nowplaying-cli ];
      example = literalExpression "[ pkgs.jq ]";
      description = ''
        Extra packages to add to PATH.
      '';
    };

    username = mkOption {
      type = types.string;
      default = "minhtung0404";
      example = "abcxyz";
      description = ''
        Your username for logging
      '';
    };
  };

  config.launchd.user.agents.sketchybar = {
    path = [ cfg.package ] ++ cfg.extraPackages
      ++ [ config.environment.systemPath ];
    serviceConfig = {
      ProgramArguments = [ "${cfg.package}/bin/sketchybar" ]
        ++ [ "--config" "${sketchybarconf}/sketchybarrc" ];
      KeepAlive = true;
      RunAtLoad = true;
      # StandardOutPath = "/tmp/sbar_out_${username}.log";
      # StandardErrorPath = "/tmp/sbar_err_${username}.log";
    };
  };
}
