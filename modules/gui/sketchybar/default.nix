{ pkgs, ... }:
{
  services.sketchybar.enable = true;
  services.sketchybar.extraPackages = [
    pkgs.lua5_4_compat
    pkgs.aerospace
    pkgs.nowplaying-cli
  ];

  launchd.user.agents.sketchybar.serviceConfig = {
    StandardOutPath = "/tmp/sbar.log";
    StandardErrorPath = "/tmp/sbar_err.log";
    };
}
