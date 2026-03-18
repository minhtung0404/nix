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

  # Power Management
  services.upower = {
    enable = true;
    criticalPowerAction = "Hibernate";

    usePercentageForPolicy = true;
    percentageCritical = 5;
    percentageLow = 10;
  };
  services.tlp.enable = true;
  services.tlp.settings = {
    CPU_SCALING_GOVERNOR_ON_AC = "performance";
    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

    CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
    CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

    CPU_MIN_PERF_ON_AC = 0;
    CPU_MAX_PERF_ON_AC = 100;
    CPU_MIN_PERF_ON_BAT = 0;
    CPU_MAX_PERF_ON_BAT = 30;

    PLATFORM_PROFILE_ON_AC = "performance";
    PLATFORM_PROFILE_ON_BAT = "low-power";

    USB_AUTOSUSPEND = 0;
  };
  services.power-profiles-daemon.enable = false;
  # powerManagement.enable = true;
  # powerManagement.powertop.enable = true;
  services.logind.settings.Login.HandleLidSwitch = "suspend-then-hibernate";
  systemd.sleep.settings.Sleep.HibernateDelaySec = "4h";

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
