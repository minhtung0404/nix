{
  self,
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    literalExpression
    mkEnableOption
    mkIf
    mkPackageOption
    mkOption
    types
    ;
  cfg = config.mtn.services.my-sketchybar;
  sketchybarconf = pkgs.runCommandCC "sketchybar-config" { } ''
    echo Creating sketchybar config
    mkdir $out

    cp -r ${./config}/* $out/

    # add images
    mkdir $out/images
    cp ${self}/images/amira_squared.jpeg $out/images/amira_squared.jpeg

    chmod -R 777 $out/helpers

    # helpers
    cd $out/helpers

    make
  '';

  username = config.mtn.username;
in
{
  options.mtn.services.my-sketchybar = {
    enable = mkEnableOption "my-sketchybar";

    package = mkPackageOption pkgs "sketchybar" { };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [
        pkgs.lua5_4_compat
        pkgs.aerospace
        pkgs.nowplaying-cli
        pkgs.sketchybar-app-font
      ];
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
          PATH = lib.concatStrings (
            (map (x: "${x}/bin/:") ([ cfg.package ] ++ cfg.extraPackages))
            ++ [
              "/Users/${username}.nix-profile/bin:/etc/profiles/per-user/${username}/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin/:/usr/local/bin/:/usr/bin/:/bin/:/usr/sbin/:/sbin"
            ]
          );
          LUA_CPATH = "${pkgs.sbarlua}/lib/lua/5.4/?.so;";
        };
        LimitLoadToSessionType = [
          "Aqua"
          "Background"
          "LoginWindow"
          "StandardIO"
          "System"
        ];
        ProcessType = "Interactive";
        ProgramArguments = [
          "${cfg.package}/bin/sketchybar"
          "--config"
          "${sketchybarconf}/sketchybarrc"
        ];
        KeepAlive = true;
        RunAtLoad = true;
        StandardOutPath = "/tmp/${username}/sbar.out.log";
        StandardErrorPath = "/tmp/${username}/sbar.err.log";
      };
    };
  };
}
