{ lib, ... }:
{
  # rclone secrets, owned by the user that includes gsync
  den.aspects.gsync-secrets =
    { user, ... }:
    {
      provides.to-hosts.os = {
        sops.secrets =
          lib.pipe
            [
              "rclone-crypt/obscured-passwd1"
              "rclone-crypt/obscured-passwd2"
              "rclone-crypt/token"
              "rclone-crypt/gdrive_client_id"
              "rclone-crypt/gdrive_client_secret"
            ]
            [
              (map (name: {
                name = name;
                value = {
                  owner = user.userName;
                  sopsFile = ./rclone.yaml;
                };
              }))
              builtins.listToAttrs
            ];
      };
    };
}
