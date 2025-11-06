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
  imports = [
    ./darwin.nix
  ];
  options.mtn.services.my-gdrive = {
    enable = lib.mkEnableOption "gdrive";
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ rclone ];

    # home-manager.users.${username}.programs.rclone = {
    #   enable = true;
    #   remotes = {
    #     google-drive = {
    #       config = {
    #         type = "drive";
    #         scope = "drive";
    #       };
    #       secrets = {
    #         token = config.sops.secrets."rclone-crypt/token".path;
    #       };
    #     };
    #     crypt = {
    #       config = {
    #         type = "crypt";
    #         remote = "google-drive:encrypted";
    #       };
    #       secrets = {
    #         password = config.sops.secrets."rclone-crypt/obscured-passwd1".path;
    #         password2 = config.sops.secrets."rclone-crypt/obscured-passwd2".path;
    #       };
    #     };
    #   };
    # };
  };
}
