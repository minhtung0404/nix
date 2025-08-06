{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mtn.programs.my-zenbrowser;
in
{
  imports = [
    inputs.zen-browser.homeModules.beta
  ];
  options.mtn.programs.my-zenbrowser = {
    enable = mkEnableOption "Zen browser";
    entertainment = mkEnableOption "Entertainment";
  };
  config = mkIf cfg.enable {
    programs.zen-browser = {
      enable = true;
      profiles.work.settings = {
        "zen.workspaces.separate-essentials" = false;
        "zen.tab-unloader.excluded-urls" =
          "mail.proton.me,calendar.proton.me,mail.google.com,mattermost.inf.telecom-sudparis.eu";
        "browser.sessionstore.restore_pinned_tabs_on_demand" = false;
      };
    }
    // (import ./firefox-fork.nix {
      inherit pkgs;
      cfg = cfg;
    });
  };
}
