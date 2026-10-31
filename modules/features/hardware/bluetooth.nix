{
  den.aspects.bluetooth.nixos = { pkgs, ... }: {
    # Bluetooth: just enable
    hardware.bluetooth.enable = true;
    hardware.bluetooth.package = pkgs.bluez5-experimental; # Why do we need experimental...?
    hardware.bluetooth.settings.General.Experimental = true;
    services.blueman.enable = true; # For a GUI
  };
}
