let
  gsyncSecrets =
    { config, lib, ... }:
    let
      username = config.mtn.constants.username;
    in
    {
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
                owner = username;
                sopsFile = ./rclone.yaml;
              };
            }))
            builtins.listToAttrs
          ];
    };
in
{
  flake.modules.nixos.gsync = gsyncSecrets;

  flake.modules.darwin.gsync = gsyncSecrets;
}
