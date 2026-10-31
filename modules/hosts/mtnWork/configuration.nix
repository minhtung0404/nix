{ den, ... }:
let
  hostname = "mtnWork";
in
{
  den.hosts.x86_64-linux.${hostname}.users.mnguyen1 = { };

  den.aspects.${hostname} = {
    includes = with den.aspects; [
      system-desktop
      kvm
      steam
    ];

    nixos = {
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
          "Philips Consumer Electronics Company PHL 241B7Q 0x00002D97" = {
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
          work = {
            output = {
              "$work" = {
                enable = true;
              };
              "$internal" = {
                enable = true;
              };
            };
            main = "Philips Consumer Electronics Company PHL 241B7Q 0x00002D97";
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

        services = {
          edns = {
            ipv6 = true;
          };
        };

        nixos.networking = {
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
  };
}
