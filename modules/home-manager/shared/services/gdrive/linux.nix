{
  lib,
  config,
  pkgs,
  sops,
  ...
}:
let
  cfg = config.mtn.services.my-gdrive;
in
{
  config = lib.mkIf (cfg.enable && pkgs.stdenv.isLinux) {
    programs.rclone = {
      enable = true;
      remotes = {
        google-drive = {
          config = {
            type = "drive";
            scope = "drive";
          };
          secrets = {
            token = sops.secrets."rclone-crypt/token".path;
          };
        };
        crypt = {
          config = {
            type = "crypt";
            remote = "google-drive:encrypted";
          };
          secrets = {
            password = sops.secrets."rclone-crypt/obscured-passwd1".path;
            password2 = sops.secrets."rclone-crypt/obscured-passwd2".path;
          };
        };
      };
    };

    # Optional: create a systemd service to sync automatically
    systemd.user.services.rclone-sync = {
      Unit = {
        Description = "Sync Google Drive using rclone";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        ExecStart = "${pkgs.rclone}/bin/rclone bisync crypt: %h/Documents/encrypted/ --resync --check-access --fast-list --drive-skip-gdocs --create-empty-src-dirs --verbose";
        Restart = "on-failure";
      };
    };

    systemd.user.timers.rclone-sync = {
      Unit = {
        Description = "Periodic rclone sync";
      };
      Install = {
        WantedBy = [ "timers.target" ];
      };
      Timer = {
        OnCalendar = "*:0/10";
        Persistent = true;
      };
    };
  };
}
