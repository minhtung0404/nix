{
  self,
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.mtn.common.linux;
in
{
  imports = [
    ../shared
    ../shared/services/kanata/linux.nix
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.sharedModules = [
        ../home-manager/nixos
      ];
    }
    inputs.sops-nix.nixosModules.sops
    inputs.niri.nixosModules.niri
  ];
  options.mtn.common.linux = {
    enable = mkOption {
      type = types.bool;
      description = "Enable the common settings for Linux personal machines";
      default = pkgs.stdenv.isLinux;
    };

    luksDevices = mkOption {
      type = types.attrsOf types.str;
      description = "A mapping from device mount name to its path (/dev/disk/...) to be mounted on boot";
      default = { };
    };

    networking = {
      hostname = mkOption {
        type = types.str;
        description = "Host name for your machine";
      };
      dnsServers = mkOption {
        type = types.listOf types.str;
        description = "DNS server list";
        default = [
          "1.1.1.1"
          "2606:4700:4700:1111"
        ];
      };
      networks = mkOption {
        type = types.attrsOf (
          types.submodule {
            options.match = mkOption {
              type = types.str;
              description = "The interface name to match";
            };
            options.isRequired = mkOption {
              type = types.bool;
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

    username = mkOption {
      type = types.str;
      description = "The linux username";
      default = "nki";
    };
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.niri.overlays.niri ];
    programs.niri.enable = true;

    services.udisks2.enable = true;

    systemd.network.enable = true;
    networking.dhcpcd.enable = lib.mkForce false;
    networking.useDHCP = false;
    networking.useNetworkd = true;
    systemd.network.wait-online.enable = false;
    networking.hostName = cfg.networking.hostname;
    networking.wireless.iwd.enable = true;
    networking.wireless.iwd.settings = {
      General.EnableNetworkConfiguration = true;
      Network = {
        UseDNS = false;
        IPv6AcceptRA = false;
      };
    };
    systemd.network.networks = builtins.mapAttrs (name: cfg: {
      matchConfig.Name = cfg.match;
      networkConfig.DHCP = "yes";
      linkConfig.RequiredForOnline = if cfg.isRequired then "yes" else "no";
    }) cfg.networking.networks;
    # Leave DNS to systemd-resolved
    services.resolved.enable = true;
    services.resolved.domains = cfg.networking.dnsServers;
    services.resolved.fallbackDns = cfg.networking.dnsServers;
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
}
