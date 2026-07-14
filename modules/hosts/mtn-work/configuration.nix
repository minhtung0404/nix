{
  config,
  self,
  ...
}:
let
  username = "mnguyen1";
in
{
  flake.nixosConfigurations = config.flake.lib.mkNixos "x86_64-linux" "mtnWork";

  flake.modules.nixos.mtnWork = { pkgs, ... }: {
    imports = [
      self.modules.nixos.system-default
      self.modules.nixos.mnguyen1
      self.modules.nixos.default
      self.modules.nixos.kanata
      self.modules.nixos.gdrive
      self.modules.nixos.battery

      self.modules.generic.sops
      self.modules.generic.edns
    ];
    mtn = {
      constants.username = username;
      services = {
        my-kanata = {
          enable = true;
          configFile = [
            "gm610_linux"
            "apple_linux"
          ];
        };
        edns = {
          # enable = true;
          ipv6 = true;
        };
      };
      programs.sops = {
        enable = true;
        file = ./secrets.yaml;
      };

      common.linux = {
        enable = true;

        networking = {
          hostname = "mtnWork";
          networks = {
            "10-wired" = {
              match = "enp*";
              isRequired = true;
            };
            "20-wireless".match = "wlan*";
          };
          dnsServers = [ "127.0.0.1" ];
        };

        username = username;
      };
    };

    networking.hostName = "mtnWork"; # Define your hostname.

    system.stateVersion = "26.05";
  };
}
