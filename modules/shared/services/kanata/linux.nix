{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    ;
  cfg = config.mtn.services.my-kanata;
in
{
  imports = [ ./config.nix ];
  config = mkIf (cfg.enable && cfg.linux) {
    systemd.services.kanata =

      let
        catString = lib.strings.concatMapStrings (
          name:
          let
            main = ./default_configs/${name}.kbd;
            common = ./default_configs/common.kbd;
          in
          ''
            cat ${main} ${common} > $out/${name}.kbd
          ''
        ) cfg.configFile;
        kanataConfig = pkgs.stdenv.mkDerivation {
          name = "kanata-config";
          phases = [ "installPhase" ];
          installPhase = ''
            mkdir -p $out
            ${catString}
          '';
        };
        argument = lib.strings.concatMapStrings (name: ''
          -c ${kanataConfig}/${name}.kbd
        '') cfg.configFile;
      in
      {
        description = "Service for kanata keyboard";
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          Type = "simple";
          ExecStart = "${cfg.package}/bin/kanata ${argument}";
          Restart = "on-failure";
          Environment = [ "LAPTOP=pc" ];
        };
      };
  };
}
