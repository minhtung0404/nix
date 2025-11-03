{
  pkgs,
  ...
}:

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

      username = "mnguyen1";
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
