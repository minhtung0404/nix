{
  pkgs,
  ...
}:
let
  username = "mnguyen1";
in
{
  imports = [
    ./hardware-configuration.nix
    {
      home-manager.users.mnguyen1 = import ./mnguyen1.nix;
    }
  ];

  mtn = {
    services = {
      my-kanata = {
        enable = true;
        linux = true;
        configFile = [
          "gm610_linux"
          "apple_linux"
        ];
      };
      edns = {
        enable = true;
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

  sops.secrets = {
    "veracrypt/drive" = {
      owner = username;
    };
    "rclone-crypt/obscured-passwd1" = {
      owner = username;
      sopsFile = ../secrets/rclone.yaml;
    };
    "rclone-crypt/obscured-passwd2" = {
      owner = username;
      sopsFile = ../secrets/rclone.yaml;
    };
    "rclone-crypt/token" = {
      owner = username;
      sopsFile = ../secrets/rclone.yaml;
    };
  };

  networking.hostName = "mtnWork"; # Define your hostname.

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mnguyen1 = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
    ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
    shell = pkgs.fish;
  };

  system.stateVersion = "25.11";
}
