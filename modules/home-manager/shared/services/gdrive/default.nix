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
  imports = [
    ./darwin.nix
    ./linux.nix
  ];
  options.mtn.services.my-gdrive = {
    enable = lib.mkEnableOption "gdrive";
  };
  config = lib.mkIf cfg.enable {
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
  };
}
