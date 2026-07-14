{
  flake.modules.nixos.gdrive =
    { config, ... }:
    let
      username = config.mtn.constants.username;
    in
    {
      sops.secrets = {
        "rclone-crypt/obscured-passwd1" = {
          owner = username;
          sopsFile = ./rclone.yaml;
        };
        "rclone-crypt/obscured-passwd2" = {
          owner = username;
          sopsFile = ./rclone.yaml;
        };
        "rclone-crypt/token" = {
          owner = username;
          sopsFile = ./rclone.yaml;
        };
      };

    };
}
