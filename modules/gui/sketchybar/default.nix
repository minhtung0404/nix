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

    # add images
    mkdir $out/images
    cp ${../../../images/amira_squared.jpeg} $out/images/amira_squared.jpeg

    chmod -R 777 $out/helpers

    # helpers
    cd $out/helpers

    make
  '';
  username = config.minhtung0404.username;
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

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];
    launchd.agents.sketchybar = {
      enable = true;
      config = {
        EnvironmentVariables = {
          PATH = lib.concatStrings
            ((map (x: "${x}/bin/:") ([ cfg.package ] ++ cfg.extraPackages)) ++ [
              "/Users/${username}.nix-profile/bin:/etc/prifiles/per-user/$USER/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin/:/usr/local/bin/:/usr/bin/:/bin/:/usr/sbin/:/sbin"
            ]);
          LUA_CPATH = "/Users/${username}/.local/share/sketchybar_lua/?.so";
        };
        ProgramArguments = [ "${cfg.package}/bin/sketchybar" ]
          ++ [ "--config" "${sketchybarconf}/sketchybarrc" ];
        KeepAlive = true;
        RunAtLoad = true;
        StandardOutPath = "/tmp/sbar_out_${username}.log";
        StandardErrorPath = "/tmp/sbar_err_${username}.log";
      };
    };
  };
}
