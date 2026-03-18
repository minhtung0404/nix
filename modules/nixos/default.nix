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
  # Modules
  modules = {
    ios =
      { config, pkgs, ... }:
      mkIf cfg.enable {
        services.usbmuxd.enable = true;
        services.usbmuxd.package = pkgs.usbmuxd2;
        environment.systemPackages = with pkgs; [
          libimobiledevice
          ifuse
        ];
        users.users.${cfg.username}.extraGroups = [ config.services.usbmuxd.group ];
        systemd.network.networks."05-ios-tethering" = {
          matchConfig.Driver = "ipheth";
          networkConfig.DHCP = "yes";
          linkConfig.RequiredForOnline = "no";
        };
      };

    graphics =
      { config, pkgs, ... }:
      {
        hardware.graphics.enable = true;
        hardware.graphics.enable32Bit = true;
        # Monitor backlight
        hardware.i2c.enable = true;
        services.ddccontrol.enable = true;
        environment.systemPackages = [
          pkgs.luminance
          pkgs.ddcutil
        ];
      };

    wlr =
      { lib, config, ... }:
      mkIf cfg.enable {
        # swaync disable notifications on screencast
        xdg.portal.wlr.settings.screencast = {
          exec_before = ''which swaync-client && swaync-client --inhibitor-add "xdg-desktop-portal-wlr" || true'';
          exec_after = ''which swaync-client && swaync-client --inhibitor-remove "xdg-desktop-portal-wlr" || true'';
        };

        # Niri stuff
        # https://github.com/sodiboo/niri-flake/blob/main/docs.md
        programs.niri.enable = true;
        # programs.niri.package = pkgs.niri-stable;
        # Override gnome-keyring disabling
        services.gnome.gnome-keyring.enable = lib.mkForce false;
        # niri
        nixpkgs.overlays = [ inputs.niri.overlays.niri ];
        programs.niri.package = pkgs.niri-stable.override {
          libdisplay-info = pkgs.libdisplay-info_0_2;
        };
      };

    kwallet =
      { pkgs, lib, ... }:
      mkIf cfg.enable {
        environment.systemPackages = [ pkgs.kdePackages.kwallet ];
        services.dbus.packages = [ pkgs.kdePackages.kwallet ];
        xdg.portal = {
          extraPortals = [ pkgs.kdePackages.kwallet ];
        };
      };

    virtualisation =
      { pkgs, ... }:
      mkIf cfg.enable {
        virtualisation.podman = {
          enable = true;
          extraPackages = [ pkgs.slirp4netns ];
          dockerCompat = true;
          defaultNetwork.settings.dns_enabled = true;
        };

        virtualisation.oci-containers.backend = "podman";

        virtualisation.virtualbox.host.enable = false;
        users.extraGroups.vboxusers.members = [ cfg.username ];
      };
  };

in
{
  imports = with modules; [
    ../shared
    ../shared/services/kanata/linux.nix
    ../shared/services/edns/linux.nix
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager = {
        sharedModules = [
          ../home-manager/nixos
        ];
        extraSpecialArgs = {
          sops = config.sops;
        };
      };
    }
    inputs.sops-nix.nixosModules.sops
    inputs.niri.nixosModules.niri
    ios
    graphics
    wlr
    kwallet
    virtualisation
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
      default = "minhtung0404";
    };
  };
  config = mkIf cfg.enable (mkMerge [
    {
      # Plasma!
      services.desktopManager.plasma6.enable = true;
      environment.systemPackages = with pkgs; [
        kdePackages.qtwebsockets
      ];
    }

    {
      ## Boot Configuration
      # Set kernel version to latest
      boot.kernelPackages = mkDefault pkgs.linuxPackages_latest;
      # Use the systemd-boot EFI boot loader.
      boot = {
        loader.timeout = 60;
        loader.systemd-boot.enable = true;
        loader.efi.canTouchEfiVariables = true;
        supportedFilesystems.ntfs = true;
      };
      boot.initrd.systemd.enable = builtins.length (builtins.attrNames (cfg.luksDevices)) > 0;
      # LUKS devices
      boot.initrd.luks.devices = builtins.mapAttrs (name: path: {
        device = path;
        preLVM = true;
        allowDiscards = true;

        crypttabExtraOpts = [
          "tpm2-device=auto"
          "fido2-device=auto"
        ];
      }) cfg.luksDevices;

      ## Hardware-related

      # Firmware stuff
      services.fwupd.enable = true;

      # Enable sound.
      services.pipewire = {
        enable = true;
        # alsa is optional
        alsa.enable = true;
        alsa.support32Bit = true;

        pulse.enable = true;
      };

      # udev configurations
      services.udev.packages = with pkgs; [
        qmk-udev-rules # For keyboards
      ];
      # Bluetooth: just enable
      hardware.bluetooth.enable = true;
      hardware.bluetooth.package = pkgs.bluez5-experimental; # Why do we need experimental...?
      hardware.bluetooth.settings.General.Experimental = true;
      services.blueman.enable = true; # For a GUI
      # ZRAM
      zramSwap.enable = true;

      # Default packages
      environment.systemPackages = with pkgs; [
        kakoune # An editor
        wget # A simple fetcher

        ## System monitoring tools
        usbutils # lsusb and friends
        pciutils # lspci and friends
        psmisc # killall, pstree, ...
        lm_sensors # sensors

        ## Security stuff
        libsForQt5.qtkeychain

        ## Wayland
        kdePackages.qtwayland
        kdePackages.okular
        rtkit
      ];

      # Add a reliable terminal
      programs.fish.enable = true;
      # AppImages should run
      programs.appimage = {
        enable = true;
        binfmt = true;
      };
      # PAM
      security.pam.services.login.enableKwallet = true;
      security.pam.services.lightdm.enableKwallet = true;
      security.pam.services.swaylock = { };
      # Printers
      services.printing.enable = true;

      # openssh
      services.openssh.enable = true;

      # udisks
      services.udisks2.enable = true;

      ## Network configuration
      systemd.network.enable = true;
      systemd.network.wait-online.enable = false;
      systemd.network.networks = builtins.mapAttrs (name: cfg: {
        matchConfig.Name = cfg.match;
        networkConfig.DHCP = "yes";
        linkConfig.RequiredForOnline = if cfg.isRequired then "yes" else "no";
      }) cfg.networking.networks;

      networking = {
        dhcpcd.enable = lib.mkForce false;
        useDHCP = false;
        useNetworkd = true;
        hostName = cfg.networking.hostname;
        wireless.iwd = {
          enable = true;
          settings = {
            General = {
              EnableNetworkConfiguration = false;
              DisablePowerSave = true;
            };
            Network = {
              UseDNS = false;
              IPv6AcceptRA = false;
            };
          };
        };
      };

      # Leave DNS to systemd-resolved
      services.resolved.enable = true;
      services.resolved.settings.Resolve = {
        Domains = cfg.networking.dnsServers;
        FallbackDNS = cfg.networking.dnsServers;
      };

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

      # Portals
      xdg.portal = {
        enable = true;
        wlr.enable = true;
        xdgOpenUsePortal = true;
        # gtk portal needed to make gtk apps happy
        extraPortals = [
          pkgs.kdePackages.xdg-desktop-portal-kde
          pkgs.xdg-desktop-portal-gtk
        ];

        config.sway.default = [
          "wlr"
          "kde"
          "kwallet"
        ];
        config.niri = {
          default = [
            "kde"
            "gnome"
            "gtk"
          ];
          # "org.freedesktop.impl.portal.Access" = "gtk";
          # "org.freedesktop.impl.portal.Notification" = "gtk";
          "org.freedesktop.impl.portal.ScreenCast" = "gnome";
          "org.freedesktop.impl.portal.Secret" = "kwallet";
          "org.freedesktop.impl.portal.FileChooser" = "kde";
        };
      };
      # D-Bus
      services.dbus.packages = with pkgs; [ gcr ];

      ## Environment
      environment.variables = {
        # Set default editor
        EDITOR = "kak";
        VISUAL = "kak";
      };

      # default settings
      # Set your time zone.
      time.timeZone = "Europe/Paris";
      # Input methods (only fcitx5 works reliably on Wayland)
      i18n.inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5.waylandFrontend = true;
        fcitx5.addons = with pkgs; [
          fcitx5-mozc
          qt6Packages.fcitx5-unikey
          fcitx5-gtk
        ];
      };

      # Enable the X11 windowing system.
      services.xserver.enable = true;

      # Enable the GNOME Desktop Environment.
      services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
      };
    }
  ]);
}
