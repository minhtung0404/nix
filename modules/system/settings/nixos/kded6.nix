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
        kded6-prestart = {
          description = "KDE Daemon (persistent, prevents on-demand D-Bus re-activation under niri)";
          partOf = [ "graphical-session.target" ];
          after = [ "graphical-session.target" ];
          wantedBy = [ "graphical-session.target" ];

          serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.kdePackages.kded}/bin/kded6";
            Restart = "on-failure";
            RestartSec = 1;
            Slice = "session.slice";
          };
        };

        xdg-desktop-portal-kde-prestart = {
          description = "Pre-started KDE portal backend";
          wantedBy = [ "graphical-session.target" ];
          after = [
            "graphical-session.target"
            "kded6-prestart.service"
          ];
          partOf = [ "graphical-session.target" ];
          serviceConfig = {
            ExecStart = "${pkgs.kdePackages.xdg-desktop-portal-kde}/libexec/xdg-desktop-portal-kde";
            Restart = "on-failure";
            RestartSec = "1s";
            Slice = "session.slice";
          };
        };

        xdg-desktop-portal-gtk = {
          after = [
            "kded6-prestart.service"
            "graphical-session.target"
          ];
        };

      };
    };
}
