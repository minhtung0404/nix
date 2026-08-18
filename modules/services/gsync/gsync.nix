{
  flake.modules.homeManager.gsync =
    {
      lib,
      config,
      pkgs,
      sops,
      ...
    }:
    lib.mkMerge [
      {
        home.packages = with pkgs; [ rclone ];
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
      }
      (lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
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
                client_id = sops.secrets."rclone-crypt/gdrive_client_id".path;
                client_secret = sops.secrets."rclone-crypt/gdrive_client_secret".path;
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
      })
    ];
}
