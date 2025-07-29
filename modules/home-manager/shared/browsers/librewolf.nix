{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mtn.programs.my-librewolf;
in
{
  options.mtn.programs.my-librewolf = {
    enable = mkEnableOption "Librewolf";
    entertainment = mkEnableOption "Entertainment";
  };
  config = mkIf cfg.enable {
    programs.librewolf = {
      enable = true;
      settings = {
        "browser.startup.page" = 3;
        "browser.tabs.groups.enabled" = true;
        "identity.fxaccounts.enabled" = true;
        "privacy.clearOnShutdown.downloads" = false;
        "privacy.clearOnShutdown.history" = false;
        "privacy.resistFingerprinting" = false;
      };
    }
    // (import ./firefox-fork.nix {
      inherit pkgs;
      cfg = cfg;
    });
  };
}
