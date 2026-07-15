{
  flake.modules.nixos.xserver = {
    # Enable the X11 windowing system.
    services.xserver.enable = true;
  };
}
