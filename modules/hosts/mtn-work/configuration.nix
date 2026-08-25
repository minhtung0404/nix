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
      ...
    }:
    {
      imports = [
        self.modules.nixos.system-desktop
        self.modules.nixos.mnguyen1

        self.modules.nixos.vm
      ];
      home-manager.users.${username} = {
        imports = [
          self.modules.homeManager.copyPaste
        ];
      };
      wrappers.kanshi = {
        monitorOutputs = {
          "eDP-1" = {
            scale = 1.0;
            position = {
              x = 0;
              y = 0;
            };
            alias = "internal";
          };
          "Lenovo Group Limited R27qe Gen2 UTP04ABB" = {
            scale = 1.0;
            position = {
              x = -2560;
              y = 0;
            };
            alias = "home-lenovo";
          };
          "DP-2" = {
            scale = 1.0;
            position = {
              x = -1920;
              y = 0;
            };
            alias = "work";
          };
        };
        profile = {
          alone = {
            output = {
              "$internal" = {
                enable = true;
              };
            };
            main = "eDP-1";
            secondary = "eDP-1";
          };

          home = {
            output = {
              "$home-lenovo" = {
                enable = true;
              };
              "$internal" = {
                enable = true;
              };
            };
            main = "Lenovo Group Limited R27qe Gen2 UTP04ABB";
            secondary = "eDP-1";
          };
        };
      };
      wrappers.niri = {
        enableLaptop = true;
      };
      wrappers.kanata.configFile = [
        "gm610_linux"
        "apple_linux"
      ];

      mtn = {
        constants.username = username;

        services = {
          edns = {
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
