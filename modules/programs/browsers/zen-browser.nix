{
  flake-file.inputs = {
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
      # to have it up-to-date or simply don't specify the nixpkgs input
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
  };

  flake.modules.homeManager.zenBrowser =
    {
      inputs,
      pkgs,
      lib,
      config,
      ...
    }:
    let
      cfg = config.mtn.programs.my-zenbrowser;
    in
    {
      imports = [
        inputs.zen-browser.homeModules.beta
      ];

      options.mtn.programs.my-zenbrowser = {
        entertainment = lib.mkEnableOption "Entertainment";
      };

      config.programs.zen-browser = {
        enable = true;
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
            settings = {
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
                # auto-tab-discard
                bitwarden
                multi-account-containers
              ];
            };
          };
        };
      };
    };
}
