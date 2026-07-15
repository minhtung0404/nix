{
  flake.modules.nixos.kded6 =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    {
      systemd.user.services = {
        kded6-persistent = {
          description = "KDE Daemon (persistent, prevents on-demand D-Bus re-activation under niri)";
          partOf = [ "graphical-session.target" ];
          after = [ "graphical-session.target" ];
          wantedBy = [ "graphical-session.target" ];

          serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.kdePackages.kded}/bin/kded6";
            Restart = "on-failure";
            RestartSec = 1;
          };
        };

        xdg-desktop-portal-gtk = {
          after = [
            "kded6-persistent.service"
            "graphical-session.target"
          ];
        };

      };
    };
}
