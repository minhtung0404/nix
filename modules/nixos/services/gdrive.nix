{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.mtn.services.my-gdrive;
in
{
  options.mtn.services.my-gdrive = {
    enable = lib.mkEnableOption "gdrive";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ rclone ];

    # Optional: create a systemd service to sync automatically
    systemd.user.services.rclone-sync = {
      description = "Sync Google Drive using rclone";
      serviceConfig = {
        ExecStart = "${pkgs.rclone}/bin/rclone bisync crypt: %h/Documents/encrypted/ --resync --check-access --fast-list --drive-skip-gdocs --create-empty-src-dirs --verbose";
        Restart = "on-failure";
      };
      wantedBy = [ "default.target" ];
    };

    systemd.user.timers.rclone-sync = {
      description = "Periodic rclone sync";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "*:0/10";
        Persistent = true;
      };
    };

    home-manager.users.${config.mtn.common.linux.username}.programs.rclone = {
      enable = true;
      remotes = {
        google-drive = {
          config = {
            type = "drive";
            scope = "drive";
          };
          secrets = {
            token = config.sops.secrets."rclone-crypt/token".path;
          };
        };
        crypt = {
          config = {
            type = "crypt";
            remote = "google-drive:encrypted";
          };
          secrets = {
            password = config.sops.secrets."rclone-crypt/obscured-passwd1".path;
            password2 = config.sops.secrets."rclone-crypt/obscured-passwd2".path;
          };
        };
      };
    };
  };
}
