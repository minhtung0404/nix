{
  inputs,
  config,
  pkgs,
  lib,
  myLib,
  ...
}:
let
  user = config.mtn.username;
  cfg = config.mtn.hm;
in
{
  imports = [
    ./darwin-defaults.nix
    ./services
    ./dock.nix
  ];

  config = lib.mkIf cfg.darwin {
    home.packages = with pkgs; [
      aldente
      hidden-bar
      raycast
      skimpdf
    ];

    mtn = {
      services = {
        my-sketchybar.enable = true;
        my-aerospace.enable = true;
      };
    };
    programs.fish.functions = {
      rebuild = {
        body = ''
          sudo darwin-rebuild switch --flake ~/.config/nix/
        '';
        wraps = "darwin-rebuild";
      };
    };
  };
}
