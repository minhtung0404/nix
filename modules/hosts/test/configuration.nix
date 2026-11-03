# A VM-only host with just the scrolling desktop (niri + noctalia):
#
#   nix run .#vm-test
#
# The VM settings (password "test", cores, memory, GL) come from den/vm.nix.
{ den, ... }:
let
  hostname = "test";
  username = "tester";
in
{
  den.hosts.x86_64-linux.${hostname}.users.${username} = { };

  den.aspects.${username} = {
    includes = [
      den.batteries.primary-user
      (den.batteries.user-shell "fish")
      den.aspects.tex
      # home config of the host aspects (desktopHome)
      den.batteries.host-aspects
    ];

    # same desktop defaults as the real users
    homeManager =
      { pkgs, config, ... }:
      {
        mtn.linux.graphical = {
          startup = [
            pkgs.obsidian
            config.mtn.linux.graphical.defaults.webBrowser.package
            # VM debugging: start dolphin at login
            pkgs.kdePackages.dolphin
          ];
          defaults.webBrowser = {
            package = config.programs.zen-browser.finalPackage;
            desktopFile = "zen.desktop";
          };
        };
      };
  };

  den.aspects.${hostname} = {
    includes = with den.aspects; [
      systemMinimal
      scrollingDesktop
      displayManager
      graphics
      bluetooth
      sound
      fish
      cliTools
      portal
      dbus
      xserver
      kwallet
      pam
      inputMethods
      udisk2
      zram
      appimage
      desktopHome
      dolphin
      polkitAgent
    ];

    nixos = {
      # never installed on real hardware; only `system.build.vm` is used
      boot.loader.grub.enable = false;
      fileSystems."/" = {
        device = "/dev/null";
        fsType = "auto";
      };
    };
  };
}
