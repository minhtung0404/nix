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
    };
  };
}
