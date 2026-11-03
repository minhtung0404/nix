{ den, lib, ... }:
let
  # rclone remotes, reading the host's sops secrets through osConfig
  rcloneRemotes =
    { osConfig, ... }:
    let
      secret = name: osConfig.sops.secrets."rclone-crypt/${name}".path;
    in
    {
      programs.rclone = {
        enable = true;
        remotes = {
          google-drive = {
            config = {
              type = "drive";
              scope = "drive";
            };
            secrets = {
              token = secret "token";
              client_id = secret "gdrive_client_id";
              client_secret = secret "gdrive_client_secret";
            };
          };
          crypt = {
            config = {
              type = "crypt";
              remote = "google-drive:encrypted";
            };
            secrets = {
              password = secret "obscured-passwd1";
              password2 = secret "obscured-passwd2";
            };
          };
        };
      };
    };
in
{
  # user aspect: include it in the users that sync with google drive
  den.aspects.gsync =
    { host, ... }:
    {
      includes = [ den.aspects.gsync-secrets ];

      homeManager =
        { ... }:
        {
          # rclone remotes only on nixos hosts
          imports = lib.optional (host.class == "nixos") rcloneRemotes;

          # installs rclone everywhere; the remotes above are nixos-only
          programs.rclone.enable = true;
          programs.fish = {
            functions = {
              gsync = {
                body = ''
                  # Ensure an argument was provided
                  if test (count $argv) -lt 1
                      echo "Usage: gsync (up|down)"
                      exit 1
                  end

                  set direction $argv[1]

                  switch $direction
                      case up
                          echo "Syncing to drive ..."
                          rclone sync ~/Documents/encrypted/ crypt: --progress

                      case down
                          echo "Syncing from drive ..."
                          rclone sync crypt: ~/Documents/encrypted/ --progress

                      case '*'
                          echo "Unknown command: $direction"
                          echo "Usage: gsync (up|down)"
                          exit 1
                  end
                '';
              };
            };
          };
        };
    };
}
