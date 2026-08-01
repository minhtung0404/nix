{
  flake.modules.nixos.network =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.mtn.nixos.networking = {
        hostname = lib.mkOption {
          type = lib.types.str;
          description = "Host name for your machine";
        };
        dnsServers = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          description = "DNS server list";
          default = [
            "1.1.1.1"
            "2606:4700:4700:1111"
          ];
        };
        networks = lib.mkOption {
          type = lib.types.attrsOf (
            lib.types.submodule {
              options.match = lib.mkOption {
                type = lib.types.str;
                description = "The interface name to match";
              };
              options.isRequired = lib.mkOption {
                type = lib.types.bool;
                description = "Require this interface to be connected for network-online.target";
                default = false;
              };
            }
          );
          description = "Network configuration";
          default = {
            default = {
              match = "*";
            };
          };
        };
      };

      config =
        let
          cfg = config.mtn.nixos.networking;
        in
        {
          ## Network configuration
          systemd.network.enable = true;
          systemd.network.wait-online.enable = false;
          systemd.network.networks = builtins.mapAttrs (name: cfg: {
            matchConfig.Name = cfg.match;
            networkConfig.DHCP = "yes";
            linkConfig.RequiredForOnline = if cfg.isRequired then "yes" else "no";
          }) cfg.networks;

          networking = {
            dhcpcd.enable = lib.mkForce false;
            useDHCP = false;
            useNetworkd = true;
            hostName = cfg.hostname;
            networkmanager.enable = true;
          };

          # Leave DNS to systemd-resolved
          services.resolved.enable = true;
          services.resolved.settings.Resolve = {
            Domains = cfg.dnsServers;
            FallbackDNS = cfg.dnsServers;
          };

          # Firewall: only open to SSH now
          networking.firewall.allowedTCPPorts = [ 22 ];
          networking.firewall.allowedUDPPorts = [ 22 ];

          # Network namespaces management
          systemd.services."netns@" = {
            description = "Network namespace %I";
            before = [ "network.target" ];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              ExecStart = "${pkgs.iproute2}/bin/ip netns add %I";
              ExecStop = "${pkgs.iproute2}/bin/ip netns del %I";
            };
          };

        };
    };
}
