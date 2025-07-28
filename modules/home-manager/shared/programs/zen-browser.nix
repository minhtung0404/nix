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
      nativeMessagingHosts = [ pkgs.firefoxpwa ];
      policies = {
        AutofillAddressEnabled = true;
        AutofillCreditCardEnabled = false;
        DisableAppUpdate = true;
        DisableFeedbackCommands = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
      };
      profiles = {
        work = {
          containersForce = true;
          containers = {
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
              id = 6;
            };
          }
          // (
            if cfg.entertainment then
              {
                Games = {
                  icon = "chill";
                  color = "green";
                  id = 7;
                };
                Manga = {
                  icon = "chill";
                  color = "yellow";
                  id = 8;
                };
                Meta = {
                  icon = "fence";
                  color = "toolbar";
                  id = 9;
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
              multi-account-containers
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
