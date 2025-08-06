{
  cfg,
  profile_settings ? { },
  pkgs,
  ...
}:
{
  # nativeMessagingHosts = [ pkgs.firefoxpwa ];
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

    PasswordManagerEnabled = false;

    SanitizeOnShutdown = {
      Cache = true;
      Cookies = true;
    };
  };
  profiles = {
    work = {
      settings = profile_settings;
      containersForce = true;
      containers = {
        ChatGPT = {
          icon = "fingerprint";
          color = "orange";
          id = 1;
        };
        Youtube = {
          icon = "chill";
          color = "toolbar";
          id = 2;
        };
      }
      // (
        if !cfg.entertainment then
          {
            Gmail = {
              icon = "fingerprint";
              color = "blue";
              id = 10;
            };
            Proton = {
              icon = "fingerprint";
              color = "turquoise";
              id = 11;
            };
            Work = {
              icon = "briefcase";
              color = "red";
              id = 12;
            };
            Study = {
              icon = "briefcase";
              color = "purple";
              id = 13;
            };
          }
        else
          {
            Games = {
              icon = "chill";
              color = "green";
              id = 20;
            };
            Manga = {
              icon = "chill";
              color = "yellow";
              id = 21;
            };
            Meta = {
              icon = "fence";
              color = "toolbar";
              id = 22;
            };
          }
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
}
