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
      profiles = {
        work = {
          containersForce = true;
          containers =
            {
              Gmail = {
                icon = "fingerprint";
                color = "blue";
                id = 1;
              };
              Proton = {
                icon = "fingerprint";
                color = "turquoise";
                id = 2;
              };
              ChatGPT = {
                icon = "fingerprint";
                color = "orange";
                id = 3;
              };
              Work = {
                icon = "briefcase";
                color = "red";
                id = 4;
              };
              Study = {
                icon = "briefcase";
                color = "purple";
                id = 5;
              };
              Youtube = {
                icon = "chill";
                color = "toolbar";
                id = 8;
              };
            }
            // (
              if cfg.entertainment then
                {
                  Games = {
                    icon = "chill";
                    color = "green";
                    id = 6;
                  };
                  Manga = {
                    icon = "chill";
                    color = "yellow";
                    id = 7;
                  };
                }
              else
                { }
            );

          extensions = {
            force = true;
            packages = with pkgs.nur.repos.rycee.firefox-addons; [
              ublock-origin
              vimium
              auto-tab-discard
              bitwarden
            ];
            settings = {
              # "uBlock0@raymondhill.net" = {
              #   settings = {
              #     selectedFilterLists = [
              #       "ublock-filters"
              #       "ublock-badware"
              #       "ublock-privacy"
              #       "ublock-unbreak"
              #       "ublock-quick-fixes"
              #     ];
              #     dynamicFilteringString = ''
              #       no-csp-reports: * true
              #       no-large-media: behind-the-scene false
              #       * * 3p-script block
              #       * * 3p-frame block
              #       behind-the-scene * * noop
              #       behind-the-scene * 1p-script noop
              #       behind-the-scene * 3p noop
              #       behind-the-scene * 3p-frame noop
              #       behind-the-scene * image noop
              #       behind-the-scene * inline-script noop
              #     '';
              #   };
              # };
            };
          };
        };
      };
    };
  };
}
