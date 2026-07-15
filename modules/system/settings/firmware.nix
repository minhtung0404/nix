{
  flake.modules.nixos.firmware = { ... }: {
    # Firmware stuff
    services.fwupd.enable = true;
  };
}
