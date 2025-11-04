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
        ExecStart = "${pkgs.rclone}/bin/rclone sync google-drive:encrypted /home/${config.mtn.common.linux.username}/Documents/encrypted/ --progress";
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

    home-manager.users.${config.mtn.common.linux.username}.programs.fish = {
      functions = {
        veramount = {
          body = ''
            function __help
              echo "Usage: veramount [OPTIONS] NAME"
              echo
              echo "Positional arguments:"
              echo "  NAME          Required. The name of the disk to mount"
              echo
              echo "Options"
              echo "  -u, --dismount Unmount the disk"
              echo "  -m, --mount    Mount the disk"
            end

            argparse -n=veramount -x dismount,mount -N 1 'd/dismount' 'm/mount' 'h/help' -- $argv
            or return 1

            if set -q _flag_help
              __help
              return 0
            end

            if test (count $argv) -lt 1
              __help
              return 1
            end

            set disk $argv[1]

            switch $disk
              case "drive"
                set src ~/Documents/encrypted/drive_encrypted
                set dst /mnt/DRIVE
                set pwd ${config.sops.secrets."veracrypt/drive".path}
                set slt 1
              case "*"
                __help
                return 1
            end

            if set -q _flag_dismount
              ${lib.getExe pkgs.veracrypt} --text --dismount $src
            else
              ${lib.getExe pkgs.veracrypt} --text --mount $src $dst --password (cat $pwd) --pim 0 --keyfiles "" --protect-hidden no --slot $slt --verbose
            end
          '';
        };
      };
    };
  };
}
