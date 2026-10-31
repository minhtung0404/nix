{
  den.aspects.firmware.nixos = { ... }: {
    # Firmware stuff
    services.fwupd.enable = true;
  };
}
