{
  config,
  ...
}:
let
  system = "x86_64-linux";
  hostname = "mtnWork";
  username = "mnguyen1";
in
{
  flake.nixosConfigurations = config.flake.lib.mkNixos system hostname;

  flake.modules.nixos.${hostname} = { self, pkgs, ... }: {
    imports = [
      self.modules.nixos.system-desktop

      self.modules.nixos.mnguyen1
    ];
    home-manager.users.${username} = {
      imports = [
        self.modules.homeManager.copyPaste
      ];
    };
    mtn = {
      constants.username = username;
      services = {
        my-kanata = {
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

      nixos.networking = {
        hostname = hostname;
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
  };
}
