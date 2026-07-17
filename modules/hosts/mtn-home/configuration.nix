# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  pkgs,
  config,
  self,
  ...
}:
let
  username = "minhtung0404";
in
{
  flake.nixosConfigurations = config.flake.lib.mkNixos "x86_64-linux" "mtnPC";

  flake.modules.nixos.mtnPC = { pkgs, ... }: {
    imports = [
      self.modules.nixos.system-desktop
      self.modules.nixos.deluge
      self.modules.nixos.minhtung0404
    ];

    home-manager.users.${username} = {
      imports = [
        self.modules.homeManager.copyPaste
      ];
    };

    mtn = {
      constants.username = username;
      programs.sops.file = ./secrets.yaml;
      services = {
        my-kanata = {
          configFile = [
            "gm610_linux"
          ];
        };
        edns = {
          ipv6 = true;
        };
      };

      nixos.networking = {
        hostname = "mtnPC";
        networks = {
          "10-wired" = {
            match = "enp*";
            isRequired = true;
          };
          "20-wireless".match = "wlan*";
        };
        dnsServers = [ "127.0.0.1" ];
      };
    };

    # mounting
    fileSystems = {
      "/mnt/Library" = {
        device = "/dev/disk/by-uuid/2A85-E011";
        fsType = "exfat";
        noCheck = true;
        options = [
          "users"
          "uid=1001"
          "gid=100"
          "umask=0000"
        ];
        neededForBoot = false;
      };
    };

    # immich
    services.immich = {
      enable = true;
      port = 2283;
      mediaLocation = "/mnt/Library/immich/";
      host = "0.0.0.0";
      openFirewall = true;
    };

    # jellyfin
    services.jellyfin = {
      enable = true;
      openFirewall = true;
    };

    # komga
    services.komga = {
      enable = true;
      openFirewall = true;
      settings = {
        config-dir = "/mnt/Library/komga/.komga/";
        server.port = 25600;
      };
    };

    # tailscale
    services.tailscale.enable = true;

    # caddy
    services.caddy = {
      enable = true;
      configFile = pkgs.writeText "Caddyfile" ''
        https://mtn-pc.dtth.ts {
            tls internal

            # Forward /komga/* to Komga at /komga/
            route /komga/* {
              reverse_proxy localhost:25600
            }

            handle_path /random-images/* {
              reverse_proxy localhost:10404
            }
            handle_path /jellyfin/* {
                reverse_proxy localhost:8096 {
                    header_up Host {host}
                    header_up X-Real-IP {remote_host}
                    header_up X-Forwarded-For {remote_host}
                    header_up X-Forwarded-Proto {scheme}
                }
            }
        }
      '';
    };
  };
}
