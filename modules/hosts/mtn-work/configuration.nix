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

  flake.modules.nixos.${hostname} =
    {
      self,
      pkgs,
      config,
      ...
    }:
    {
      imports = [
        self.modules.nixos.system-desktop

        self.modules.nixos.mnguyen1
      ];
      home-manager.users.${username} = {
        imports = [
          self.modules.homeManager.copyPaste
        ];
      };
      wrappers.niri = {
        enableLaptop = true;
        monitors = {
          main = "DP-2";
          secondary = "eDP-1";
        };
        monitorOutputs = {
          "DP-2" = {
            scale = 1.0;
            position = _: {
              props = {
                x = 0;
                y = 0;
              };
            };
            focus-at-startup = _: { };
          };
          "eDP-1" = {
            scale = 1.0;
            position = _: {
              props = {
                x = 1920;
                y = 0;
              };
            };
          };
        };
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
