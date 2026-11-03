{ den, ... }:
{
  # expansion of cli system for desktop use

  den.aspects.systemDesktop = {
    includes = with den.aspects; [
      systemCli
      kanata

      scrollingDesktop
      displayManager
      ios
      graphics
      monitorBacklight
      bluetooth
      boot
      firmware
      sound
      kwallet
      virtualisation
      network
      udev
      zram
      appimage
      pam
      printing
      udisk2
      openssh
      portal
      xserver
      inputMethods
      dbus
      dolphin
      polkitAgent
      okular
      intellij
      timezone

      desktopHome
    ];
  };
}
