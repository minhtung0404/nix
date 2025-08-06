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
    }
    // (import ./firefox-fork.nix {
      inherit pkgs;
      cfg = cfg;
      profile_settings = {
        "zen.tab-unloader.excluded-urls" = [
          "mail.proton.me"
          "calendar.proton.me"
          "mail.google.com"
          "mattermost.inf.telecom-sudparis.eu"
        ];
        "browser.sessionstore.restore_pinned_tabs_on_demand" = false;
        "zen.urlbar.behavior" = "float";
        "zen.view.compact.hide-tabbar" = false;
        "zen.view.compact.hide-toolbar" = true;
        "zen.view.compact.should-enable-at-startup" = true;
        "zen.view.use-single-toolbar" = false;
        "zen.workspaces.separate-essentials" = false;
      };

    });
  };
}
