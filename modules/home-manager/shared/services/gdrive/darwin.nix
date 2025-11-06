{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.mtn.services.my-gdrive;
  username = config.mtn.username;
in
{
  config = lib.mkIf (cfg.enable && pkgs.stdenv.isDarwin) {
    # Optional: create a systemd service to sync automatically
    launchd.agents.rclone-sync = {
      enable = true;
      config = {
        Label = "com.nixos.rclone-sync";
        ProgramArguments = [
          "${pkgs.rclone}/bin/rclone"
          "bisync"
          "crypt:"
          "${config.home.homeDirectory}/Documents/encrypted/"
          "--resync"
          "--check-access"
          "--fast-list"
          "--drive-skip-gdocs"
          "--create-empty-src-dirs"
          "--verbose"
        ];
        StartInterval = 600;
        RunAtLoad = true;
        KeepAlive = {
          SuccessfulExit = false; # Restart if it crashes
        };
        StandardOutPath = "/tmp/${username}/rclone/out.log";
        StandardErrorPath = "/tmp/${username}/rclone/err.log";
      };
    };
  };
}
