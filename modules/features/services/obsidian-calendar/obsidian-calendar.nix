{ lib, ... }:
let
  calendars = [
    {
      id = "phd";
      name = "PhD";
      color = "#0072d4";
      tags = [ "🎓/PhD" ];
      folders = [ "2. Areas/??-PhD" ];
    }
    {
      id = "ta";
      name = "TA";
      color = "#489100";
      tags = [ "🎓/TA" ];
      folders = [ ];
    }
    {
      id = "personal";
      name = "Personal";
      color = "#ca4898";
      tags = [
        "Life"
        "People"
      ];
      folders = [ "2. Areas/Life" ];
    }
    {
      id = "other";
      name = "Other";
      color = "#909995";
      tags = [ ];
      folders = [ ];
    }
  ];

  port = 5232;
  ztAddress = "10.124.123.16";
  httpsPort = 5233;
  certPort = 5234;
  owner = "calendar";
  writer = "obsidian";
  secret = name: "obsidian-calendar/${name}";
in
{
  den.aspects.obsidianCalendar =
    { user, ... }:
    {
      provides.to-hosts.nixos =
        { config, ... }:
        {
          sops.secrets = {
            ${secret "radicale-users"} = {
              key = "radicale-users";
              sopsFile = ./secrets.yaml;
              owner = "radicale";
              restartUnits = [ "radicale.service" ];
            };
            ${secret "writer-password"} = {
              key = "writer-password";
              sopsFile = ./secrets.yaml;
              owner = user.userName;
            };
            ${secret "reader-password"} = {
              key = "reader-password";
              sopsFile = ./secrets.yaml;
              owner = user.userName;
            };
          };

          networking.firewall.interfaces."zt+".allowedTCPPorts = [
            httpsPort
            certPort
          ];

          services.caddy = {
            enable = true;
            globalConfig = ''
              skip_install_trust
              auto_https disable_redirects
              # iOS sends no SNI when connecting to an IP address
              default_sni ${ztAddress}
            '';
            virtualHosts."https://${ztAddress}:${toString httpsPort}".extraConfig = ''
              tls internal
              reverse_proxy 127.0.0.1:${toString port}
            '';
            virtualHosts."http://:${toString certPort}".extraConfig = ''
              root * ${config.services.caddy.dataDir}/.local/share/caddy/pki/authorities/local
              rewrite * /root.crt
              header Content-Type application/x-x509-ca-cert
              file_server
            '';
          };

          services.radicale = {
            enable = true;
            settings = {
              server.hosts = [ "127.0.0.1:${toString port}" ];
              auth = {
                type = "htpasswd";
                htpasswd_filename = config.sops.secrets.${secret "radicale-users"}.path;
                htpasswd_encryption = "autodetect";
              };
              rights.type = "from_file";
            };
            # the writer owns the calendars under /calendar/; the reader may only read them
            rights = {
              writer = {
                user = writer;
                collection = "${owner}(/[^/]+)?";
                permissions = "RrWw";
              };
              root = {
                user = ".+";
                collection = "";
                permissions = "R";
              };
              reader-principal = {
                user = owner;
                collection = owner;
                permissions = "R";
              };
              reader-calendars = {
                user = owner;
                collection = "${owner}/[^/]+";
                permissions = "r";
              };
            };
          };

          # one Noctalia account per calendar, so each keeps its own color
          # (needs a host with the noctalia wrapper, i.e. scrollingDesktop)
          wrappers.noctalia.settings.calendar = {
            enabled = true;
            refresh_minutes = 5;
            account = lib.listToAttrs (
              map (c: {
                name = "obsidian_${c.id}";
                value = {
                  type = "caldav";
                  provider = "custom";
                  inherit (c) name color;
                  server_url = "http://127.0.0.1:${toString port}/";
                  username = owner;
                  credential_source = "file";
                  password_file = config.sops.secrets.${secret "reader-password"}.path;
                  calendars = [ c.id ];
                };
              }) calendars
            );
            reminders = {
              enabled = true;
              use_event_reminders = true;
              default_lead_minutes = 10;
              all_day_digest_time = "09:00";
            };
          };
        };

      homeManager =
        {
          config,
          osConfig,
          pkgs,
          ...
        }:
        let
          settings = {
            vault = "${config.home.homeDirectory}/Documents/encrypted/LifeOS";
            server = "http://127.0.0.1:${toString port}/";
            username = writer;
            password_file = osConfig.sops.secrets.${secret "writer-password"}.path;
            inherit owner calendars;
            timezone = "Europe/Paris";
            past_days = 60;
            default_duration_minutes = 120;
            default_reminders_timed = [ "15m" ];
            default_reminders_allday = [ "0" ];
            allday_reminder_time = "09:00";
            exclude = [
              "0. PeriodicNotes"
              "1. Projects/Template.md"
              "2. Areas/Template.md"
              "5. Templates"
            ];
          };
          configFile = pkgs.writeText "obsidian-calendar.json" (builtins.toJSON settings);
          script = pkgs.writeScriptBin "obsidian-calendar" ''
            #!${lib.getExe pkgs.python3} -I
            ${builtins.readFile ./obsidian-calendar.py}
          '';

          wrapper = pkgs.writeShellScriptBin "obsidian-calendar" ''
            exec ${lib.getExe script} ${configFile} "$@"
          '';
        in
        {
          home.packages = [ wrapper ];

          systemd.user.services.obsidian-calendar = {
            Unit = {
              Description = "Export dated Obsidian tasks to the CalDAV calendars";
              After = [ "network.target" ];
            };
            Service = {
              Type = "oneshot";
              ExecStart = lib.getExe wrapper;
            };
          };
          systemd.user.timers.obsidian-calendar = {
            Unit.Description = "Export Obsidian tasks to CalDAV every 2 minutes";
            Timer = {
              OnStartupSec = "1min";
              OnUnitActiveSec = "2min";
            };
            Install.WantedBy = [ "timers.target" ];
          };
        };
    };
}
