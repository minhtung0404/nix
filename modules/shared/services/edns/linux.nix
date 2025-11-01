{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mtn.services.edns;
in
{
  config = lib.mkIf (pkgs.stdenv.isLinux && cfg.enable) {
    networking.nameservers = [
      "127.0.0.1"
      "::1"
    ];
    networking.resolvconf.enable = lib.mkOverride 1000 false;
    networking.dhcpcd.extraConfig = "nohook resolv.conf";
    networking.networkmanager.dns = "none";
  };
}
