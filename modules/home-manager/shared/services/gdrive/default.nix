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
  };
}
